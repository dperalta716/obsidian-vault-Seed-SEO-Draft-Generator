#!/bin/bash

# Copy a sheet to another spreadsheet or within the same spreadsheet
# Usage: ./copy-sheet.sh "user@example.com" "source_spreadsheet_id" "sheet_id" "destination_spreadsheet_id"

set -euo pipefail

USER_EMAIL="$1"
SOURCE_SPREADSHEET_ID="$2"
SHEET_ID="$3"
DEST_SPREADSHEET_ID="$4"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Prepare request body
REQUEST_BODY=$(jq -n \
  --arg destId "$DEST_SPREADSHEET_ID" \
  '{destinationSpreadsheetId: $destId}')

# Copy sheet
RESPONSE=$(curl -s -X POST \
  "https://sheets.googleapis.com/v4/spreadsheets/${SOURCE_SPREADSHEET_ID}/sheets/${SHEET_ID}:copyTo" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

echo "$RESPONSE" | jq '.'
