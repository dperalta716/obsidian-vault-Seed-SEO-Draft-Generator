#!/bin/bash

# List files in a Google Drive folder
# Usage: ./list-files.sh "user@example.com" [folder_id] [max_results]

set -euo pipefail

USER_EMAIL="$1"
FOLDER_ID="${2:-root}"
MAX_RESULTS="${3:-1000}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build query to list files in folder
QUERY="'${FOLDER_ID}' in parents and trashed=false"
ENCODED_QUERY=$(printf '%s' "$QUERY" | jq -sRr @uri)

# List files
RESPONSE=$(curl -s \
  "https://www.googleapis.com/drive/v3/files?q=${ENCODED_QUERY}&pageSize=${MAX_RESULTS}&fields=files(id,name,mimeType,size,modifiedTime,webViewLink,parents)" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return files
echo "$RESPONSE" | jq '.files'
