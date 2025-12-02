#!/bin/bash

# Execute batchUpdate on a Google Doc with custom requests
# Usage: ./batch-update.sh "user@example.com" "document_id" "requests_json_or_file"
# requests_json_or_file can be a JSON string or path to a JSON file containing an array of requests

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"
REQUESTS="$3"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Check if REQUESTS is a file or JSON string
if [[ -f "$REQUESTS" ]]; then
  REQUEST_BODY=$(jq -n \
    --slurpfile requests "$REQUESTS" \
    '{requests: $requests[0]}')
else
  REQUEST_BODY=$(jq -n \
    --argjson requests "$REQUESTS" \
    '{requests: $requests}')
fi

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
