#!/bin/bash

# Create a new sheet within an existing spreadsheet
# Usage: ./create-sheet.sh "user@example.com" "spreadsheet_id" "New Sheet Name"

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"
SHEET_NAME="$3"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Prepare batchUpdate request
REQUEST_BODY=$(jq -n \
  --arg title "$SHEET_NAME" \
  '{
    requests: [
      {
        addSheet: {
          properties: {
            title: $title
          }
        }
      }
    ]
  }')

# Create sheet
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

echo "$RESPONSE" | jq '.replies[0].addSheet.properties'
