#!/bin/bash

# Insert an image into a Google Doc
# Usage: ./insert-image.sh "user@example.com" "document_id" "image_uri" "index" [width] [height]

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
IMAGE_URI="$3"
INDEX="$4"
WIDTH="${5:-null}"
HEIGHT="${6:-null}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/batch-requests.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build insert inline image request
IMAGE_REQUEST=$(build_insert_inline_image_request "$IMAGE_URI" "$INDEX" "$WIDTH" "$HEIGHT")

# Create requests array
REQUEST_BODY=$(jq -n \
  --argjson req "$IMAGE_REQUEST" \
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
