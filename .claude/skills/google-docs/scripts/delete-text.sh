#!/bin/bash

# Delete text range in a Google Doc
# Usage: ./delete-text.sh "user@example.com" "document_id" "start_index" "end_index"

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
START_INDEX="$3"
END_INDEX="$4"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/batch-requests.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build delete content request
DELETE_REQUEST=$(build_delete_content_request "$START_INDEX" "$END_INDEX")

# Create requests array
REQUEST_BODY=$(jq -n \
  --argjson req "$DELETE_REQUEST" \
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
