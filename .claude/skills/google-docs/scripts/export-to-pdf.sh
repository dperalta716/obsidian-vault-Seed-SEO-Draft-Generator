#!/bin/bash

# Export a Google Doc to PDF format and save to Drive
# Usage: ./export-to-pdf.sh "user@example.com" "document_id" [pdf_filename] [folder_id]

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
PDF_FILENAME="${3:-}"
FOLDER_ID="${4:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Step 1: Get document metadata to get title if filename not provided
if [[ -z "$PDF_FILENAME" ]]; then
  DOC_RESPONSE=$(curl -s \
    "https://docs.googleapis.com/v1/documents/${DOCUMENT_ID}?fields=title" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}")

  DOC_TITLE=$(echo "$DOC_RESPONSE" | jq -r '.title')
  PDF_FILENAME="${DOC_TITLE}_PDF"
fi

# Step 2: Export document to PDF format using Drive API
EXPORT_RESPONSE=$(curl -s \
  "https://www.googleapis.com/drive/v3/files/${DOCUMENT_ID}/export?mimeType=application/pdf" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -o "/tmp/${PDF_FILENAME}.pdf")

# Check if export was successful (file exists)
if [[ ! -f "/tmp/${PDF_FILENAME}.pdf" ]]; then
  echo '{"error": {"message": "PDF export failed"}}' >&2
  exit 1
fi

# Step 3: Upload PDF back to Drive
# Create file metadata
PARENTS_JSON="[]"
if [[ -n "$FOLDER_ID" ]]; then
  PARENTS_JSON="[\"$FOLDER_ID\"]"
fi

METADATA=$(jq -n \
  --arg name "${PDF_FILENAME}.pdf" \
  --argjson parents "$PARENTS_JSON" \
  '{name: $name, mimeType: "application/pdf"} + (if ($parents | length) > 0 then {parents: $parents} else {} end)')

# Upload using multipart upload
BOUNDARY="foo_bar_baz"
UPLOAD_RESPONSE=$(curl -s -X POST \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: multipart/related; boundary=${BOUNDARY}" \
  --data-binary @- <<EOF
--${BOUNDARY}
Content-Type: application/json; charset=UTF-8

${METADATA}

--${BOUNDARY}
Content-Type: application/pdf

$(cat "/tmp/${PDF_FILENAME}.pdf")
--${BOUNDARY}--
EOF
)

# Clean up temp file
rm "/tmp/${PDF_FILENAME}.pdf"

# Check for errors
if echo "$UPLOAD_RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$UPLOAD_RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return response with file details
echo "$UPLOAD_RESPONSE" | jq '{
  id,
  name,
  mimeType,
  webViewLink: ("https://drive.google.com/file/d/" + .id + "/view")
}'
