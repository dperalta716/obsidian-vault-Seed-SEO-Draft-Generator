#!/bin/bash

# Get values from multiple ranges in a single request
# Usage: ./batch-get.sh "user@example.com" "spreadsheet_id" "Sheet1!A1:B2,Sheet1!D4:E5,Sheet2!A1:C3"

set -euo pipefail

USER_EMAIL="$1"
SPREADSHEET_ID="$2"
RANGES="$3"  # Comma-separated list of ranges

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Convert comma-separated ranges to URL parameters
RANGE_PARAMS=$(echo "$RANGES" | sed 's/,/\&ranges=/g')
RANGE_PARAMS="ranges=${RANGE_PARAMS}"

# Get values from multiple ranges
RESPONSE=$(curl -s -G \
  "https://sheets.googleapis.com/v4/spreadsheets/${SPREADSHEET_ID}/values:batchGet" \
  --data-urlencode "$RANGE_PARAMS" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

echo "$RESPONSE" | jq '.'
