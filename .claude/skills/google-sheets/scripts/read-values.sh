#!/bin/bash

# Read values from a specific range in a Google Sheet
# Usage: ./read-values.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:D10"

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"
RANGE="${3:-A1:Z1000}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# URL encode spaces and exclamation marks in the range (preserve : and other range syntax)
# First remove bash escape sequences, then encode
ENCODED_RANGE=$(printf '%s' "$RANGE" | sed -e 's/\\!/!/g' -e 's/ /%20/g' -e 's/!/%21/g')

# Read values
RESPONSE=$(curl -s \
  "https://sheets.googleapis.com/v4/spreadsheets/${SPREADSHEET_ID}/values/${ENCODED_RANGE}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return values
echo "$RESPONSE" | jq '.'
