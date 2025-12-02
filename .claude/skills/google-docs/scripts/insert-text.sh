#!/bin/bash

# Insert text at a specific index in a Google Doc
# Usage: ./insert-text.sh "user@example.com" "document_id" "index" "text to insert"

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
INDEX="$3"
TEXT="$4"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/batch-requests.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build insert text request
INSERT_REQUEST=$(build_insert_text_request "$TEXT" "$INDEX")

# Create requests array
REQUEST_BODY=$(jq -n \
  --argjson req "$INSERT_REQUEST" \
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
