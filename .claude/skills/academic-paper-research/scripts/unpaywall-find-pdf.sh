#!/bin/bash
# unpaywall-find-pdf.sh - Find legal open-access PDF URLs for a DOI
# Indexes legal OA copies from publisher sites, institutional repositories, and preprint servers
#
# Usage: ./unpaywall-find-pdf.sh <doi>
#   doi: DOI to look up (required) - with or without https://doi.org/ prefix
#
# Example: ./unpaywall-find-pdf.sh "10.3390/nu11092048"
# Example: ./unpaywall-find-pdf.sh "https://doi.org/10.1038/nrgastro.2014.66"
#
# Returns: JSON with best open-access PDF URL and all available locations

DOI="$1"

if [ -z "$DOI" ]; then
    echo "Error: DOI required"
    echo "Usage: ./unpaywall-find-pdf.sh <doi>"
    exit 1
fi

# Load shared config (email for Unpaywall API)
source "$(dirname "$0")/config.sh"

# Clean up DOI
CLEAN_DOI=$(echo "$DOI" | sed 's|https://doi.org/||' | sed 's|http://doi.org/||' | sed 's|doi.org/||')

# URL encode the DOI
ENCODED_DOI=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$CLEAN_DOI', safe=''))")

# Query Unpaywall API (email required)
RESULT=$(curl -s -w "\n%{http_code}" \
    "https://api.unpaywall.org/v2/${ENCODED_DOI}?email=${CONTACT_EMAIL}")

HTTP_CODE=$(echo "$RESULT" | tail -1)
BODY=$(echo "$RESULT" | sed '$d')

if [ "$HTTP_CODE" != "200" ]; then
    echo '{
  "doi": "'"$CLEAN_DOI"'",
  "is_open_access": false,
  "error": "DOI not found in Unpaywall",
  "http_code": '"$HTTP_CODE"'
}'
    exit 0
fi

# Parse response
echo "$BODY" | python3 -c "
import sys, json

try:
    data = json.load(sys.stdin)

    is_oa = data.get('is_oa', False)
    best_loc = data.get('best_oa_location', {}) or {}

    result = {
        'doi': '$CLEAN_DOI',
        'doi_url': 'https://doi.org/$CLEAN_DOI',
        'is_open_access': is_oa,
        'title': data.get('title', ''),
        'journal': data.get('journal_name', ''),
        'year': data.get('year', None),
        'publisher': data.get('publisher', '')
    }

    if is_oa and best_loc:
        result['best_pdf_url'] = best_loc.get('url_for_pdf', '') or best_loc.get('url', '')
        result['best_landing_page'] = best_loc.get('url_for_landing_page', '')
        result['host_type'] = best_loc.get('host_type', '')
        result['license'] = best_loc.get('license', '')
        result['version'] = best_loc.get('version', '')

        # All available locations
        all_locs = data.get('oa_locations', [])
        locations = []
        for loc in all_locs:
            locations.append({
                'url': loc.get('url_for_pdf', '') or loc.get('url', ''),
                'host_type': loc.get('host_type', ''),
                'version': loc.get('version', ''),
                'license': loc.get('license', '')
            })
        result['all_locations'] = locations
    else:
        result['best_pdf_url'] = ''
        result['note'] = 'No open-access version found. Paper is behind a paywall.'

    print(json.dumps(result, indent=2))

except Exception as e:
    print(json.dumps({
        'doi': '$CLEAN_DOI',
        'is_open_access': False,
        'error': str(e)
    }, indent=2))
"
