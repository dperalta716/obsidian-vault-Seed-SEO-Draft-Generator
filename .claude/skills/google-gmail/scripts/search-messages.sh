#!/bin/bash

# Search Gmail messages
# Usage: ./search-messages.sh "user@example.com" "query" [page_size]

set -euo pipefail

USER_EMAIL="$1"
QUERY="$2"
PAGE_SIZE="${3:-10}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# URL encode the query
ENCODED_QUERY=$(echo -n "$QUERY" | jq -sRr @uri)

# Search messages
RESPONSE=$(curl -s \
  "https://gmail.googleapis.com/gmail/v1/users/me/messages?q=${ENCODED_QUERY}&maxResults=${PAGE_SIZE}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return messages with metadata
echo "$RESPONSE" | jq '.'
