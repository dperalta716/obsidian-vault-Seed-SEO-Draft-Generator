#!/bin/bash

# Create a new text file in Google Drive
# Usage: ./create-file.sh "user@example.com" "filename" "content" [parent_folder_id] [mime_type]

set -euo pipefail

USER_EMAIL="$1"
FILE_NAME="$2"
CONTENT="$3"
PARENT_FOLDER_ID="${4:-root}"
MIME_TYPE="${5:-text/plain}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Create file metadata
METADATA=$(jq -n \
  --arg name "$FILE_NAME" \
  --arg mimeType "$MIME_TYPE" \
  --arg parent "$PARENT_FOLDER_ID" \
  '{name: $name, mimeType: $mimeType, parents: [$parent]}')

# Create multipart request body
BOUNDARY="foo_bar_baz"
BODY="--${BOUNDARY}
Content-Type: application/json; charset=UTF-8

${METADATA}

--${BOUNDARY}
Content-Type: ${MIME_TYPE}

${CONTENT}
--${BOUNDARY}--"

# Upload file
RESPONSE=$(curl -s -X POST \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart&fields=id,name,webViewLink" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: multipart/related; boundary=${BOUNDARY}" \
  --data-binary "$BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return created file info
echo "$RESPONSE" | jq '.'
