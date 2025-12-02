#!/bin/bash

# Get information about a specific spreadsheet including its sheets
# Usage: ./get-spreadsheet-info.sh "user@example.com" "spreadsheet_id"

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Get spreadsheet info
RESPONSE=$(curl -s \
  "https://sheets.googleapis.com/v4/spreadsheets/${SPREADSHEET_ID}?fields=spreadsheetId,properties,sheets(properties)" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return spreadsheet info
echo "$RESPONSE" | jq '.'
