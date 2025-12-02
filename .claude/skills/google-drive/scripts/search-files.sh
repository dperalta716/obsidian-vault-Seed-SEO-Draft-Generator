#!/bin/bash

# Search for files in Google Drive
# Usage: ./search-files.sh "user@example.com" "name contains 'report'" [max_results]

set -euo pipefail

USER_EMAIL="$1"
QUERY="$2"
MAX_RESULTS="${3:-100}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# URL encode the query
ENCODED_QUERY=$(printf '%s' "$QUERY" | jq -sRr @uri)

# Search for files
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
