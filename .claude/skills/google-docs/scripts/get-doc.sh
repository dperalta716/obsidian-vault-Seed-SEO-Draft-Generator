#!/bin/bash

# Get Google Doc content and structure
# Usage: ./get-doc.sh "user@example.com" "document_id"

set -euo pipefail

USER_EMAIL="$1"
DOCUMENT_ID="$2"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Get document
RESPONSE=$(curl -s \
  "https://docs.googleapis.com/v1/documents/${DOCUMENT_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return full document
echo "$RESPONSE" | jq '.'
