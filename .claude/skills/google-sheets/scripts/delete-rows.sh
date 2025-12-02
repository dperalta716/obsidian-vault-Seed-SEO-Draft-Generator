#!/bin/bash

# Delete rows from a Google Sheet
# Usage: ./delete-rows.sh "user@example.com" "spreadsheet_id" "sheet_id" "start_index" "num_rows"

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"
SHEET_ID="$3"
START_INDEX="$4"  # 0-based row index where to start deleting
NUM_ROWS="$5"     # Number of rows to delete

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Calculate end index
END_INDEX=$((START_INDEX + NUM_ROWS))

# Prepare batchUpdate request
REQUEST_BODY=$(jq -n \
  --argjson sheetId "$SHEET_ID" \
  --argjson startIndex "$START_INDEX" \
  --argjson endIndex "$END_INDEX" \
  '{
    requests: [
      {
        deleteDimension: {
          range: {
            sheetId: $sheetId,
            dimension: "ROWS",
            startIndex: $startIndex,
            endIndex: $endIndex
          }
        }
      }
    ]
  }')

# Delete rows
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
