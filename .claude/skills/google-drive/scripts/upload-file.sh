#!/bin/bash

# Upload a local file to Google Drive
# Usage: ./upload-file.sh "user@example.com" "local_file_path" [parent_folder_id] [mime_type]

set -euo pipefail

USER_EMAIL="$1"
LOCAL_FILE="$2"
PARENT_FOLDER_ID="${3:-root}"
MIME_TYPE="${4:-}"

# Check if file exists
if [[ ! -f "$LOCAL_FILE" ]]; then
  echo '{"error": {"message": "Local file not found: '"$LOCAL_FILE"'"}}' >&2
  exit 1
fi

FILE_NAME=$(basename "$LOCAL_FILE")

# Auto-detect MIME type if not specified
if [[ -z "$MIME_TYPE" ]]; then
  case "${FILE_NAME##*.}" in
    pdf) MIME_TYPE="application/pdf" ;;
    jpg|jpeg) MIME_TYPE="image/jpeg" ;;
    png) MIME_TYPE="image/png" ;;
    txt) MIME_TYPE="text/plain" ;;
    html|htm) MIME_TYPE="text/html" ;;
    json) MIME_TYPE="application/json" ;;
    csv) MIME_TYPE="text/csv" ;;
    docx) MIME_TYPE="application/vnd.openxmlformats-officedocument.wordprocessingml.document" ;;
    xlsx) MIME_TYPE="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ;;
    pptx) MIME_TYPE="application/vnd.openxmlformats-officedocument.presentationml.presentation" ;;
    *) MIME_TYPE="application/octet-stream" ;;
  esac
fi

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

# Create multipart request
BOUNDARY="foo_bar_baz"

RESPONSE=$(curl -s -X POST \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart&fields=id,name,webViewLink,mimeType,size" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: multipart/related; boundary=${BOUNDARY}" \
  --data-binary @- <<EOF
--${BOUNDARY}
Content-Type: application/json; charset=UTF-8

${METADATA}

--${BOUNDARY}
Content-Type: ${MIME_TYPE}

$(cat "$LOCAL_FILE")
--${BOUNDARY}--
EOF
)

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return uploaded file info
echo "$RESPONSE" | jq '.'
