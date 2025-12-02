#!/bin/bash

# Batch delete multiple Gmail messages permanently
# Usage: ./batch-delete.sh "user@example.com" "message_id1,message_id2,message_id3"

set -euo pipefail

USER_EMAIL="$1"
MESSAGE_IDS="$2"  # Comma-separated list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Convert comma-separated list to JSON array
MSG_ARRAY="[]"
IFS=',' read -ra IDS <<< "$MESSAGE_IDS"
for MSG_ID in "${IDS[@]}"; do
  MSG_ID=$(echo "$MSG_ID" | xargs)  # Trim whitespace
  MSG_ARRAY=$(echo "$MSG_ARRAY" | jq --arg id "$MSG_ID" '. + [$id]')
done

# Build request body
REQUEST_BODY=$(jq -n \
  --argjson ids "$MSG_ARRAY" \
  '{ids: $ids}')

# Batch delete messages
RESPONSE=$(curl -s -X POST \
  "https://gmail.googleapis.com/gmail/v1/users/me/messages/batchDelete" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return success (batchDelete returns empty on success)
if [[ -z "$RESPONSE" || "$RESPONSE" == "{}" ]]; then
  jq -n \
    --argjson count "$(echo "$MSG_ARRAY" | jq 'length')" \
    '{
      success: true,
      messagesDeleted: $count
    }'
else
  echo "$RESPONSE" | jq '.'
fi
