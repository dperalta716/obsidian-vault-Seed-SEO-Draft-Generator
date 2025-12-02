#!/bin/bash

# Format cells in a Google Sheet (bold, italic, colors, etc.)
# Usage: ./format-cells.sh "user@example.com" "spreadsheet_id" "sheet_id" "start_row" "end_row" "start_col" "end_col" '{"bold":true,"italic":false,"backgroundColor":{"red":1,"green":0,"blue":0}}'

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"
SHEET_ID="$3"
START_ROW="$4"
END_ROW="$5"
START_COL="$6"
END_COL="$7"
FORMAT_JSON="$8"  # JSON object with formatting properties

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build the format fields string from the JSON keys
FORMAT_FIELDS=$(echo "$FORMAT_JSON" | jq -r 'keys | map("userEnteredFormat." + .) | join(",")')

# Prepare batchUpdate request
REQUEST_BODY=$(jq -n \
  --argjson sheetId "$SHEET_ID" \
  --argjson startRow "$START_ROW" \
  --argjson endRow "$END_ROW" \
  --argjson startCol "$START_COL" \
  --argjson endCol "$END_COL" \
  --argjson format "$FORMAT_JSON" \
  --arg fields "$FORMAT_FIELDS" \
  '{
    requests: [
      {
        repeatCell: {
          range: {
            sheetId: $sheetId,
            startRowIndex: $startRow,
            endRowIndex: $endRow,
            startColumnIndex: $startCol,
            endColumnIndex: $endCol
          },
          cell: {
            userEnteredFormat: $format
          },
          fields: $fields
        }
      }
    ]
  }')

# Apply formatting
RESPONSE=$(curl -s -X POST \
  "https://sheets.googleapis.com/v4/spreadsheets/${SPREADSHEET_ID}:batchUpdate" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

echo "$RESPONSE" | jq '.'
