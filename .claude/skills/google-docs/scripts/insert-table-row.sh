#!/bin/bash

# Insert a row into an existing table in a Google Doc
# Usage: ./insert-table-row.sh "user@example.com" "document_id" "table_start_index" "row_index" [insert_below]

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
TABLE_START_INDEX="$3"
ROW_INDEX="$4"
INSERT_BELOW="${5:-true}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/batch-requests.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build insert table row request
ROW_REQUEST=$(build_insert_table_row_request "$TABLE_START_INDEX" "$ROW_INDEX" "$INSERT_BELOW")

# Create requests array
REQUEST_BODY=$(jq -n \
  --argjson req "$ROW_REQUEST" \
  '{requests: [$req]}')

# Execute batchUpdate
RESPONSE=$(curl -s -X POST \
  "https://docs.googleapis.com/v1/documents/${DOCUMENT_ID}:batchUpdate" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return response
echo "$RESPONSE" | jq '.'
