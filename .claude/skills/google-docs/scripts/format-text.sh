#!/bin/bash

# Apply text formatting (bold, italic, font size, font family) to a range in a Google Doc
# Usage: ./format-text.sh "user@example.com" "document_id" "start_index" "end_index" [bold] [italic] [font_size] [font_family]

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
START_INDEX="$3"
END_INDEX="$4"
BOLD="${5:-null}"
ITALIC="${6:-null}"
FONT_SIZE="${7:-null}"
FONT_FAMILY="${8:-null}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/batch-requests.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build update text style request
FORMAT_REQUEST=$(build_update_text_style_request "$START_INDEX" "$END_INDEX" "$BOLD" "$ITALIC" "$FONT_SIZE" "$FONT_FAMILY")

# Create requests array
REQUEST_BODY=$(jq -n \
  --argjson req "$FORMAT_REQUEST" \
  '{requests: [$req]}')

# Execute batchUpdate
RESPONSE=$(curl -s -X POST \
  "https://docs.googleapis.com/v1/documents/${DOCUMENT_ID}:batchUpdate" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return response
echo "$RESPONSE" | jq '.'
