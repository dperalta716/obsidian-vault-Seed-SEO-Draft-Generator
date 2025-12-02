#!/bin/bash

# Copy a file in Google Drive
# Usage: ./copy-file.sh "user@example.com" "file_id" "new_name" [parent_folder_id]

set -euo pipefail

USER_EMAIL="$1"
FILE_ID="$2"
NEW_NAME="$3"
PARENT_FOLDER_ID="${4:-}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build request body
if [[ -n "$PARENT_FOLDER_ID" ]]; then
  REQUEST_BODY=$(jq -n \
    --arg name "$NEW_NAME" \
    --arg parent "$PARENT_FOLDER_ID" \
    '{name: $name, parents: [$parent]}')
else
  REQUEST_BODY=$(jq -n \
    --arg name "$NEW_NAME" \
    '{name: $name}')
fi

# Copy file
RESPONSE=$(curl -s -X POST \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}/copy?fields=id,name,webViewLink,mimeType,parents" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return copied file info
echo "$RESPONSE" | jq '.'
