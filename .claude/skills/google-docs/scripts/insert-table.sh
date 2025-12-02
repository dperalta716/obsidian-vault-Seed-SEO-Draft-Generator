#!/bin/bash

# Insert a table into a Google Doc
# Usage: ./insert-table.sh "user@example.com" "document_id" "rows" "columns" "index"

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
ROWS="$3"
COLUMNS="$4"
INDEX="$5"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/batch-requests.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build insert table request
TABLE_REQUEST=$(build_insert_table_request "$ROWS" "$COLUMNS" "$INDEX")

# Create requests array
REQUEST_BODY=$(jq -n \
  --argjson req "$TABLE_REQUEST" \
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
