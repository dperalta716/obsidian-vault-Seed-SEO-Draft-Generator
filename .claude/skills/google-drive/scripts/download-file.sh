#!/bin/bash

# Download file content from Google Drive
# Usage: ./download-file.sh "user@example.com" "file_id" [output_path]

set -euo pipefail

USER_EMAIL="$1"
FILE_ID="$2"
OUTPUT_PATH="${3:-}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Get file metadata to determine MIME type and name
METADATA=$(curl -s \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}?fields=id,name,mimeType" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}")

# Check for errors
if echo "$METADATA" | jq -e '.error' > /dev/null 2>&1; then
  echo "$METADATA" | jq '.error' >&2
  exit 1
fi

MIME_TYPE=$(echo "$METADATA" | jq -r '.mimeType')
FILE_NAME=$(echo "$METADATA" | jq -r '.name')

# Determine output path
if [[ -z "$OUTPUT_PATH" ]]; then
  OUTPUT_PATH="./${FILE_NAME}"
fi

# Check if this is a Google Workspace file that needs export
if [[ "$MIME_TYPE" == "application/vnd.google-apps.document" ]]; then
  # Google Docs - export to DOCX
  EXPORT_MIME="application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  OUTPUT_PATH="${OUTPUT_PATH%.gdoc}.docx"
elif [[ "$MIME_TYPE" == "application/vnd.google-apps.spreadsheet" ]]; then
  # Google Sheets - export to XLSX
  EXPORT_MIME="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  OUTPUT_PATH="${OUTPUT_PATH%.gsheet}.xlsx"
elif [[ "$MIME_TYPE" == "application/vnd.google-apps.presentation" ]]; then
  # Google Slides - export to PPTX
  EXPORT_MIME="application/vnd.openxmlformats-officedocument.presentationml.presentation"
  OUTPUT_PATH="${OUTPUT_PATH%.gslides}.pptx"
elif [[ "$MIME_TYPE" == application/vnd.google-apps.* ]]; then
  echo '{"error": {"message": "Unsupported Google Workspace file type: '"$MIME_TYPE"'"}}' >&2
  exit 1
else
  # Regular file - direct download
  curl -s -o "$OUTPUT_PATH" \
    "https://www.googleapis.com/drive/v3/files/${FILE_ID}?alt=media" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}"

  echo "{\"success\": true, \"message\": \"File downloaded to ${OUTPUT_PATH}\", \"path\": \"${OUTPUT_PATH}\"}"
  exit 0
fi

# Export Google Workspace file
curl -s -o "$OUTPUT_PATH" \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}/export?mimeType=${EXPORT_MIME}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}"

echo "{\"success\": true, \"message\": \"File exported and downloaded to ${OUTPUT_PATH}\", \"path\": \"${OUTPUT_PATH}\"}"
