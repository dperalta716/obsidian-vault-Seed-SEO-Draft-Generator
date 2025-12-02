#!/bin/bash

# Permanently delete Gmail message
# Usage: ./delete-message.sh "user@example.com" "message_id"

set -euo pipefail

USER_EMAIL="$1"
MESSAGE_ID="$2"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Delete message
RESPONSE=$(curl -s -X DELETE \
  "https://gmail.googleapis.com/gmail/v1/users/me/messages/${MESSAGE_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}")

# Return success (DELETE returns empty on success)
if [[ -z "$RESPONSE" ]]; then
  jq -n \
    --arg id "$MESSAGE_ID" \
    '{
      success: true,
      message: "Message permanently deleted",
      messageId: $id
    }'
else
  # Check for errors
  if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
    echo "$RESPONSE" | jq '.error' >&2
    exit 1
  fi
  echo "$RESPONSE" | jq '.'
fi
