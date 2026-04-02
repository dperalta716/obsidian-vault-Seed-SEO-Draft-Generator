#!/bin/bash
# scihub-fetch.sh - Last-resort paper retrieval via Sci-Hub
# Use ONLY when all legal methods (PubMed, CrossRef, Semantic Scholar, Unpaywall) have failed
# Tries multiple Sci-Hub mirrors and extracts the embedded PDF URL
#
# Usage: ./scihub-fetch.sh <doi_or_url>
#   doi_or_url: DOI, DOI URL, or direct paper URL (required)
#
# Example: ./scihub-fetch.sh "10.1016/j.cell.2019.01.024"
# Example: ./scihub-fetch.sh "https://doi.org/10.1016/j.cell.2019.01.024"
#
# Returns: JSON with PDF URL if found
#
# LEGAL NOTE: Sci-Hub operates in a legal gray area. This script is provided
# for research verification purposes. Always try legal methods first.

INPUT="$1"

if [ -z "$INPUT" ]; then
    echo "Error: DOI or URL required"
    echo "Usage: ./scihub-fetch.sh <doi_or_url>"
    exit 1
fi

# Clean up input - normalize to DOI if possible
CLEAN_INPUT=$(echo "$INPUT" | sed 's|https://doi.org/||' | sed 's|http://doi.org/||' | sed 's|doi.org/||')

# Sci-Hub mirrors to try (update this list if mirrors change)
MIRRORS=("sci-hub.se" "sci-hub.st" "sci-hub.ru")

FOUND=false
PDF_URL=""
MIRROR_USED=""

for MIRROR in "${MIRRORS[@]}"; do
    # Try to fetch the Sci-Hub page
    RESPONSE=$(curl -s -L --max-time 15 \
        -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
        "https://${MIRROR}/${CLEAN_INPUT}" 2>/dev/null)

    if [ -z "$RESPONSE" ]; then
        continue
    fi

    # Extract PDF URL from the page
    # Sci-Hub embeds the PDF in an iframe or embed tag
    PDF_URL=$(echo "$RESPONSE" | python3 -c "
import sys, re

html = sys.stdin.read()

# Try iframe src
match = re.search(r'<iframe[^>]+src=[\"'\''](.*?\.pdf[^\"'\'']*)[\"'\'']', html, re.IGNORECASE)
if match:
    print(match.group(1))
    sys.exit(0)

# Try embed src
match = re.search(r'<embed[^>]+src=[\"'\''](.*?\.pdf[^\"'\'']*)[\"'\'']', html, re.IGNORECASE)
if match:
    print(match.group(1))
    sys.exit(0)

# Try direct PDF link pattern
match = re.search(r'(https?://[^\s\"'\''<>]+\.pdf)', html, re.IGNORECASE)
if match:
    print(match.group(1))
    sys.exit(0)

# Try the #pdf button/link pattern
match = re.search(r'location\.href\s*=\s*[\"'\''](.*?\.pdf[^\"'\'']*)[\"'\'']', html, re.IGNORECASE)
if match:
    print(match.group(1))
    sys.exit(0)

print('')
" 2>/dev/null)

    if [ -n "$PDF_URL" ]; then
        # Ensure URL is absolute
        if [[ "$PDF_URL" == //* ]]; then
            PDF_URL="https:${PDF_URL}"
        elif [[ "$PDF_URL" == /* ]]; then
            PDF_URL="https://${MIRROR}${PDF_URL}"
        fi
        MIRROR_USED="$MIRROR"
        FOUND=true
        break
    fi
done

if [ "$FOUND" = true ]; then
    echo '{
  "doi": "'"$CLEAN_INPUT"'",
  "found": true,
  "pdf_url": "'"$PDF_URL"'",
  "mirror_used": "'"$MIRROR_USED"'",
  "note": "Retrieved via Sci-Hub. For verification purposes only. Legal open-access methods were exhausted."
}'
else
    echo '{
  "doi": "'"$CLEAN_INPUT"'",
  "found": false,
  "pdf_url": "",
  "mirrors_tried": "'"$(IFS=,; echo "${MIRRORS[*]}")"'",
  "note": "Paper not found on any Sci-Hub mirror. All mirrors may be down or the paper may not be in their database."
}'
fi
