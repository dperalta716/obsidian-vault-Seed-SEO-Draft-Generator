#!/bin/bash

# Create a new Google Doc
# Usage: ./create-doc.sh "user@example.com" "Document Title"

set -euo pipefail

USER_EMAIL="$1"
TITLE="$2"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Create document
REQUEST_BODY=$(jq -n \
  --arg title "$TITLE" \
  '{title: $title}')

RESPONSE=$(curl -s -X POST \
  "https://docs.googleapis.com/v1/documents" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return document ID and details
echo "$RESPONSE" | jq '{documentId, title, revisionId, documentUrl: ("https://docs.google.com/document/d/" + .documentId + "/edit")}'
