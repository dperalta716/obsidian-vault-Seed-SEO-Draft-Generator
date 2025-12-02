#!/bin/bash

# Set data validation rules on a range in a Google Sheet
# Usage: ./set-data-validation.sh "user@example.com" "spreadsheet_id" "sheet_id" "start_row" "end_row" "start_col" "end_col" '{"condition":{"type":"NUMBER_GREATER","values":[{"userEnteredValue":"0"}]},"showCustomUi":true}'

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"
SHEET_ID="$3"
START_ROW="$4"
END_ROW="$5"
START_COL="$6"
END_COL="$7"
VALIDATION_RULE="$8"  # JSON object with validation rule

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Prepare batchUpdate request
REQUEST_BODY=$(jq -n \
  --argjson sheetId "$SHEET_ID" \
  --argjson startRow "$START_ROW" \
  --argjson endRow "$END_ROW" \
  --argjson startCol "$START_COL" \
  --argjson endCol "$END_COL" \
  --argjson rule "$VALIDATION_RULE" \
  '{
    requests: [
      {
        setDataValidation: {
          range: {
            sheetId: $sheetId,
            startRowIndex: $startRow,
            endRowIndex: $endRow,
            startColumnIndex: $startCol,
            endColumnIndex: $endCol
          },
          rule: $rule
        }
      }
    ]
  }')

# Set data validation
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
