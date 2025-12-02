#!/bin/bash

# Update file metadata (rename or change description)
# Usage: ./update-metadata.sh "user@example.com" "file_id" [new_name] [description]

set -euo pipefail

USER_EMAIL="$1"
FILE_ID="$2"
NEW_NAME="${3:-}"
DESCRIPTION="${4:-}"

# Check that at least one parameter is provided
if [[ -z "$NEW_NAME" && -z "$DESCRIPTION" ]]; then
  echo '{"error": {"message": "At least one of new_name or description must be provided"}}' >&2
  exit 1
fi

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build request body
if [[ -n "$NEW_NAME" && -n "$DESCRIPTION" ]]; then
  REQUEST_BODY=$(jq -n \
    --arg name "$NEW_NAME" \
    --arg desc "$DESCRIPTION" \
    '{name: $name, description: $desc}')
elif [[ -n "$NEW_NAME" ]]; then
  REQUEST_BODY=$(jq -n \
    --arg name "$NEW_NAME" \
    '{name: $name}')
else
  REQUEST_BODY=$(jq -n \
    --arg desc "$DESCRIPTION" \
    '{description: $desc}')
fi

# Update file metadata
RESPONSE=$(curl -s -X PATCH \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}?fields=id,name,description,modifiedTime" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return updated file metadata
echo "$RESPONSE" | jq '.'
