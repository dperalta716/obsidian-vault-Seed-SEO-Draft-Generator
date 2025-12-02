#!/bin/bash

# Clear values from multiple ranges in a single request
# Usage: ./batch-clear.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:B2,Sheet1!D4:E5,Sheet2!A1:C3"

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"
RANGES="$3"  # Comma-separated list of ranges

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Convert comma-separated ranges to JSON array
RANGES_JSON=$(echo "$RANGES" | jq -R 'split(",")')

# Prepare request body
REQUEST_BODY=$(jq -n \
  --argjson ranges "$RANGES_JSON" \
  '{ranges: $ranges}')

# Batch clear values
RESPONSE=$(curl -s -X POST \
  "https://sheets.googleapis.com/v4/spreadsheets/${SPREADSHEET_ID}/values:batchClear" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

echo "$RESPONSE" | jq '.'
