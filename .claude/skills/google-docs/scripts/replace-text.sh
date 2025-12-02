#!/bin/bash

# Find and replace text throughout a Google Doc
# Usage: ./replace-text.sh "user@example.com" "document_id" "find_text" "replace_text" [match_case]

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
FIND_TEXT="$3"
REPLACE_TEXT="$4"
MATCH_CASE="${5:-false}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/batch-requests.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build replace all text request
REPLACE_REQUEST=$(build_replace_all_text_request "$FIND_TEXT" "$REPLACE_TEXT" "$MATCH_CASE")

# Create requests array
REQUEST_BODY=$(jq -n \
  --argjson req "$REPLACE_REQUEST" \
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

# Return response with replacement count
echo "$RESPONSE" | jq '.'
