#!/bin/bash
#
# bulk-upload-reference.sh
# Bulk uploads all Reference folder files to a File Search store
#
# Usage: ./bulk-upload-reference.sh STORE_NAME [--dry-run] [--limit N]
#

set -e  # Exit on error (but continue loop on upload failures)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}ERROR: Store name required${NC}" >&2
    echo "Usage: $0 STORE_NAME [--dry-run] [--limit N]"
    exit 1
fi

STORE_NAME="$1"
DRY_RUN=false
LIMIT=0

# Parse optional flags
shift
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}" >&2
            exit 1
            ;;
    esac
done

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Reference directory (relative to project root)
# Script is in: dev/active/reference-store-setup/scripts/
# Project root is 4 levels up
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REFERENCE_DIR="$PROJECT_ROOT/Reference"

if [ ! -d "$REFERENCE_DIR" ]; then
    echo -e "${RED}ERROR: Reference directory not found: $REFERENCE_DIR${NC}" >&2
    exit 1
fi

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}Bulk Upload to File Search Store${NC}"
echo -e "${CYAN}=========================================${NC}"
echo "Store: $STORE_NAME"
echo "Reference Dir: $REFERENCE_DIR"
echo "Dry Run: $DRY_RUN"
if [ $LIMIT -gt 0 ]; then
    echo "Limit: $LIMIT files"
fi
echo ""

# Function to extract category from path
get_category() {
    local path="$1"
    if [[ $path == *"/Claims/"* ]]; then echo "Claims"
    elif [[ $path == *"/NPD-Messaging/"* ]]; then echo "NPD-Messaging"
    elif [[ $path == *"/SciComms"* ]]; then echo "SciComms"
    elif [[ $path == *"/Compliance/"* ]]; then echo "Compliance"
    elif [[ $path == *"/Style/"* ]]; then echo "Style"
    else echo "Other"
    fi
}

# Function to extract product from filename/path
get_product() {
    local filename="$1"
    if [[ $filename == *"AM-02"* ]]; then echo "AM-02"
    elif [[ $filename == *"DM-02"* ]]; then echo "DM-02"
    elif [[ $filename == *"PM-02"* ]]; then echo "PM-02"
    elif [[ $filename == *"Cross-Product"* ]]; then echo "Cross-Product"
    else echo "N/A"
    fi
}

# Function to extract file type from filename
get_file_type() {
    local filename="$1"

    # Order matters - check specific patterns first
    if [[ $filename == *"-General-Claims.md" ]]; then echo "General-Claims"
    elif [[ $filename == *"-Key-Benefits-Claims.md" ]]; then echo "Key-Benefits-Claims"
    elif [[ $filename == *"-Formula-Overview.md" ]] || [[ $filename == *"-Product-Formulation.md" ]]; then echo "Formula"
    elif [[ $filename == *"-Claims.md" ]]; then echo "Ingredient-Claims"  # Any file ending in -Claims.md (after checking specific patterns above)
    elif [[ $filename == *"Product Messaging"* ]]; then echo "Messaging"
    elif [[ $filename == *"SciComms"* ]] && [[ $filename == *"Education"* ]]; then echo "Education"
    elif [[ $filename == "NO-NO-WORDS.md" ]] || [[ $filename == *"Not-Allowed"* ]]; then echo "Compliance"
    elif [[ $filename == *"Tone-Guide"* ]] || [[ $filename == *"Tone-of-Voice"* ]]; then echo "Tone-Guide"
    elif [[ $filename == *"Sample"* ]]; then echo "Sample-Articles"
    elif [[ $filename == *"Process-Instructions"* ]]; then echo "Process-Instructions"
    else echo "Other"
    fi
}

# Find all markdown files (excluding backups and non-md files)
echo -e "${BLUE}Finding markdown files in Reference directory...${NC}"

FILES=()
while IFS= read -r -d '' file; do
    filename=$(basename "$file")

    # Skip backup files
    if [[ $filename == *.backup-* ]]; then
        continue
    fi

    # Skip non-markdown files that might be in Reference
    if [[ $filename == *.py ]] || [[ $filename == *.txt ]] || [[ $filename == *.sh ]]; then
        continue
    fi

    FILES+=("$file")
done < <(find "$REFERENCE_DIR" -type f -name "*.md" -print0 | sort -z)

TOTAL_FILES=${#FILES[@]}

echo -e "${GREEN}Found $TOTAL_FILES markdown files${NC}"
echo ""

if [ $TOTAL_FILES -eq 0 ]; then
    echo -e "${YELLOW}No files to upload${NC}"
    exit 0
fi

# Apply limit if specified
if [ $LIMIT -gt 0 ] && [ $LIMIT -lt $TOTAL_FILES ]; then
    TOTAL_FILES=$LIMIT
    echo -e "${YELLOW}Limiting to first $LIMIT files${NC}"
    echo ""
fi

# Upload counters
SUCCESS_COUNT=0
FAILED_COUNT=0
FAILED_FILES=()

START_TIME=$(date +%s)

# Upload each file
for i in "${!FILES[@]}"; do
    # Check limit
    if [ $LIMIT -gt 0 ] && [ $i -ge $LIMIT ]; then
        break
    fi

    FILE="${FILES[$i]}"
    FILE_NUM=$((i + 1))

    # Get relative path from Reference/
    REL_PATH="${FILE#$REFERENCE_DIR/}"

    # Extract metadata
    FILENAME=$(basename "$FILE")
    CATEGORY=$(get_category "$FILE")
    PRODUCT=$(get_product "$FILENAME")
    FILE_TYPE=$(get_file_type "$FILENAME")

    # Build metadata JSON
    METADATA="[{\"key\":\"category\",\"string_value\":\"$CATEGORY\"},{\"key\":\"product\",\"string_value\":\"$PRODUCT\"},{\"key\":\"file_type\",\"string_value\":\"$FILE_TYPE\"},{\"key\":\"relative_path\",\"string_value\":\"$REL_PATH\"}]"

    echo -e "${CYAN}[$FILE_NUM/$TOTAL_FILES] $REL_PATH${NC}"
    echo "  Category: $CATEGORY, Product: $PRODUCT, Type: $FILE_TYPE"

    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${YELLOW}[DRY RUN] Would upload with metadata:${NC}"
        echo "  $METADATA" | jq '.'
    else
        # Upload file
        set +e  # Don't exit on upload failure
        UPLOAD_OUTPUT=$("$SCRIPT_DIR/upload-file.sh" "$STORE_NAME" "$FILE" "$METADATA" "$FILENAME" 2>&1)
        UPLOAD_EXIT_CODE=$?
        set -e

        if [ $UPLOAD_EXIT_CODE -eq 0 ]; then
            echo -e "  ${GREEN}✓ Success${NC}"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))

            # Extract operation name if available
            OPERATION=$(echo "$UPLOAD_OUTPUT" | grep -o '"name": "[^"]*"' | head -1 | cut -d'"' -f4)
            if [ -n "$OPERATION" ]; then
                echo "  Operation: $OPERATION"
            fi
        else
            echo -e "  ${RED}✗ Failed${NC}"
            FAILED_COUNT=$((FAILED_COUNT + 1))
            FAILED_FILES+=("$REL_PATH")

            # Show error details
            echo -e "${RED}  Error output:${NC}"
            echo "$UPLOAD_OUTPUT" | head -10
        fi

        # Rate limiting: 2-second delay between uploads (except last file)
        if [ $FILE_NUM -lt $TOTAL_FILES ]; then
            sleep 2
        fi
    fi

    echo ""
done

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Final summary
echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}Bulk Upload Complete${NC}"
echo -e "${CYAN}=========================================${NC}"
echo "Total Files: $TOTAL_FILES"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN - No files were actually uploaded${NC}"
else
    echo -e "${GREEN}Successful: $SUCCESS_COUNT${NC}"
    if [ $FAILED_COUNT -gt 0 ]; then
        echo -e "${RED}Failed: $FAILED_COUNT${NC}"
        echo ""
        echo "Failed files:"
        for failed_file in "${FAILED_FILES[@]}"; do
            echo "  - $failed_file"
        done
    else
        echo -e "${GREEN}Failed: 0${NC}"
    fi
    echo "Duration: ${DURATION}s"
fi

echo "Store Name: $STORE_NAME"
echo -e "${CYAN}=========================================${NC}"

# Exit with error if any uploads failed
if [ $FAILED_COUNT -gt 0 ]; then
    exit 1
fi
