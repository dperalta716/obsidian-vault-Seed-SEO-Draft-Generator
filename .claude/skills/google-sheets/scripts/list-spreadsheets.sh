#!/bin/bash

# List spreadsheets from Google Drive
# Usage: ./list-spreadsheets.sh "user@example.com" [max_results]

set -euo pipefail

USER_EMAIL="$1"
MAX_RESULTS="${2:-25}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Search for Google Sheets using Drive API
RESPONSE=$(curl -s \
  "https://www.googleapis.com/drive/v3/files?q=mimeType='application/vnd.google-apps.spreadsheet'&pageSize=${MAX_RESULTS}&fields=files(id,name,modifiedTime,webViewLink)" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return files
echo "$RESPONSE" | jq '.files'
