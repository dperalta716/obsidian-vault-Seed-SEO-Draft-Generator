#!/bin/bash

# Write values to a specific range in a Google Sheet
# Usage: ./write-values.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:B2" '[[\"value1\",\"value2\"],[\"value3\",\"value4\"]]'

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"
RANGE="$3"
VALUES="$4"  # JSON 2D array

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Remove bash escape sequences
CLEAN_RANGE=$(printf '%s' "$RANGE" | sed 's/\\!/!/g')

# URL encode spaces and exclamation marks for URL path
ENCODED_RANGE=$(printf '%s' "$CLEAN_RANGE" | sed -e 's/ /%20/g' -e 's/!/%21/g')

# Prepare request body with cleaned range
REQUEST_BODY=$(jq -n \
  --argjson values "$VALUES" \
  --arg range "$CLEAN_RANGE" \
  '{values: $values, range: $range}')

# Write values
RESPONSE=$(curl -s -X PUT \
  "https://sheets.googleapis.com/v4/spreadsheets/${SPREADSHEET_ID}/values/${ENCODED_RANGE}?valueInputOption=USER_ENTERED" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

echo "$RESPONSE" | jq '.'
