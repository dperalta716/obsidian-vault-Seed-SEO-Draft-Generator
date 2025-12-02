#!/bin/bash

# Update values in multiple ranges in a single request
# Usage: ./batch-update.sh "user@example.com" "spreadsheet_id" '[{"range":"Sheet1!A1:B2","values":[[\"a\",\"b\"]]},{"range":"Sheet2!A1","values":[[\"c\"]]}]'

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"
DATA="$3"  # JSON array of {range, values} objects

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Prepare request body
REQUEST_BODY=$(jq -n \
  --argjson data "$DATA" \
  '{
    valueInputOption: "USER_ENTERED",
    data: $data
  }')

# Batch update values
RESPONSE=$(curl -s -X POST \
  "https://sheets.googleapis.com/v4/spreadsheets/${SPREADSHEET_ID}/values:batchUpdate" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

echo "$RESPONSE" | jq '.'
