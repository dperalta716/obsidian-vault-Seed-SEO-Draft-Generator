#!/bin/bash

# Export Google Workspace file to specific format
# Usage: ./export-file.sh "user@example.com" "file_id" "mime_type" [output_path]

set -euo pipefail

USER_EMAIL="$1"
FILE_ID="$2"
EXPORT_MIME="$3"
OUTPUT_PATH="${4:-}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Get file name if output path not specified
if [[ -z "$OUTPUT_PATH" ]]; then
  METADATA=$(curl -s \
    "https://www.googleapis.com/drive/v3/files/${FILE_ID}?fields=name" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}")

  FILE_NAME=$(echo "$METADATA" | jq -r '.name')

  # Determine extension from MIME type
  case "$EXPORT_MIME" in
    "application/pdf") EXT=".pdf" ;;
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document") EXT=".docx" ;;
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") EXT=".xlsx" ;;
    "application/vnd.openxmlformats-officedocument.presentationml.presentation") EXT=".pptx" ;;
    "text/plain") EXT=".txt" ;;
    "text/html") EXT=".html" ;;
    "text/csv") EXT=".csv" ;;
    *) EXT="" ;;
  esac

  OUTPUT_PATH="./${FILE_NAME}${EXT}"
fi

# Export file
RESPONSE=$(curl -s -w "\n%{http_code}" -o "$OUTPUT_PATH" \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}/export?mimeType=${EXPORT_MIME}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

if [[ "$HTTP_CODE" != "200" ]]; then
  echo "{\"error\": {\"code\": ${HTTP_CODE}, \"message\": \"Export failed\"}}" >&2
  rm -f "$OUTPUT_PATH"
  exit 1
fi

echo "{\"success\": true, \"message\": \"File exported to ${OUTPUT_PATH}\", \"path\": \"${OUTPUT_PATH}\"}"
