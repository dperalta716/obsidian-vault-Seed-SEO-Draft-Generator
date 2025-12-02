#!/bin/bash

# Move file between folders in Google Drive
# Usage: ./move-file.sh "user@example.com" "file_id" "new_folder_id"
# CRITICAL: Required for upload-to-gdocs workflows

set -euo pipefail

USER_EMAIL="$1"
FILE_ID="$2"
NEW_FOLDER_ID="$3"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Step 1: Get current parent folder ID
CURRENT_PARENT_RESPONSE=$(curl -s \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}?fields=parents" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}")

# Check for errors
if echo "$CURRENT_PARENT_RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$CURRENT_PARENT_RESPONSE" | jq '.error' >&2
  exit 1
fi

CURRENT_PARENT=$(echo "$CURRENT_PARENT_RESPONSE" | jq -r '.parents[0]')

if [[ -z "$CURRENT_PARENT" || "$CURRENT_PARENT" == "null" ]]; then
  echo '{"error": {"message": "Could not determine current parent folder"}}' >&2
  exit 1
fi

# Step 2: Move file to new folder
RESPONSE=$(curl -s -X PATCH \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}?addParents=${NEW_FOLDER_ID}&removeParents=${CURRENT_PARENT}&fields=id,name,parents" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return updated file metadata
echo "$RESPONSE" | jq '.'
