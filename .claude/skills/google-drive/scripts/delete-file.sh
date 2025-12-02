#!/bin/bash

# Permanently delete a file from Google Drive
# Usage: ./delete-file.sh "user@example.com" "file_id"

set -euo pipefail

USER_EMAIL="$1"
FILE_ID="$2"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Delete file
RESPONSE=$(curl -s -w "\n%{http_code}" -X DELETE \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

if [[ "$HTTP_CODE" != "204" && "$HTTP_CODE" != "200" ]]; then
  BODY=$(echo "$RESPONSE" | head -n -1)
  if [[ -n "$BODY" ]]; then
    echo "$BODY" | jq '.error' >&2
  else
    echo "{\"error\": {\"code\": ${HTTP_CODE}, \"message\": \"Delete failed\"}}" >&2
  fi
  exit 1
fi

echo "{\"success\": true, \"message\": \"File ${FILE_ID} permanently deleted\"}"
