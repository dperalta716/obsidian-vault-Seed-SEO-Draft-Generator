#!/bin/bash

# Populate a table with data in a Google Doc
# Usage: ./populate-table.sh "user@example.com" "document_id" "table_start_index" "data_json"
# data_json should be a 2D array like [["cell1","cell2"],["cell3","cell4"]]

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
TABLE_START_INDEX="$3"
DATA_JSON="$4"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/batch-requests.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# First, get the document to find cell positions
DOC_RESPONSE=$(curl -s \
  "https://docs.googleapis.com/v1/documents/${DOCUMENT_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}")

# Parse the table structure to find cell insertion indices
# This is complex - we need to find the table at TABLE_START_INDEX and get all cell positions
# For now, we'll use a simplified approach: insert text requests in reverse order

# Build array of insert text requests from the data
REQUESTS="[]"
ROW_INDEX=0

echo "$DATA_JSON" | jq -c '.[]' | while IFS= read -r row; do
  COL_INDEX=0
  echo "$row" | jq -c '.[]' | while IFS= read -r cell; do
    # Calculate approximate cell index (this is simplified - real implementation would parse table structure)
    # Each table cell has a start index that needs to be determined from the document structure
    # For this script to work properly, it should be combined with inspect-structure.sh

    CELL_TEXT=$(echo "$cell" | jq -r '.')

    # This is a placeholder - actual implementation requires document structure parsing
    # to determine correct cell insertion indices
    echo "Warning: populate-table.sh requires document structure parsing to determine cell positions" >&2
    echo "Use inspect-structure.sh first, then use insert-text.sh or batch-update.sh manually" >&2
    exit 1

    COL_INDEX=$((COL_INDEX + 1))
  done
  ROW_INDEX=$((ROW_INDEX + 1))
done

# Note: A complete implementation would:
# 1. Parse the document structure from get-doc.sh to find all table cell start indices
# 2. Build insert text requests for each cell
# 3. Execute all requests in a single batchUpdate call

echo '{"error": {"message": "populate-table.sh requires manual implementation with document structure parsing. Use batch-update.sh with parsed cell indices instead."}}' >&2
exit 1
