#!/bin/bash

# Create a new Google Spreadsheet
# Usage: ./create-spreadsheet.sh "user@example.com" "Spreadsheet Title" ["Sheet1,Sheet2,Sheet3"]

set -euo pipefail

USER_EMAIL="$1"
TITLE="$2"
SHEET_NAMES="${3:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build sheets array
if [[ -n "$SHEET_NAMES" ]]; then
  # Convert comma-separated names to JSON array
  SHEETS_JSON=$(echo "$SHEET_NAMES" | jq -R 'split(",") | map({properties: {title: .}})')
else
  SHEETS_JSON='[]'
fi

# Prepare request body
REQUEST_BODY=$(jq -n \
  --arg title "$TITLE" \
  --argjson sheets "$SHEETS_JSON" \
  '{
    properties: {title: $title},
    sheets: $sheets
  }')

# Create spreadsheet
RESPONSE=$(curl -s -X POST \
  "https://sheets.googleapis.com/v4/spreadsheets" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return spreadsheet info with URL
echo "$RESPONSE" | jq '{
  spreadsheetId,
  properties,
  sheets: [.sheets[].properties],
  spreadsheetUrl
}'
