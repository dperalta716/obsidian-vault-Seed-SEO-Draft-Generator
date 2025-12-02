#!/bin/bash

# Modify labels on a Gmail message
# Usage: ./modify-message-labels.sh "user@example.com" "message_id" "add_label_ids" "remove_label_ids"
# Example: ./modify-message-labels.sh "user@example.com" "abc123" "Label_1,Label_2" "INBOX,UNREAD"

set -euo pipefail

USER_EMAIL="$1"
MESSAGE_ID="$2"
ADD_LABELS="${3:-}"  # Comma-separated list
REMOVE_LABELS="${4:-}"  # Comma-separated list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Convert comma-separated lists to JSON arrays
ADD_ARRAY="[]"
if [[ -n "$ADD_LABELS" ]]; then
  IFS=',' read -ra ADD_IDS <<< "$ADD_LABELS"
  for LABEL in "${ADD_IDS[@]}"; do
    LABEL=$(echo "$LABEL" | xargs)  # Trim whitespace
    ADD_ARRAY=$(echo "$ADD_ARRAY" | jq --arg label "$LABEL" '. + [$label]')
  done
fi

REMOVE_ARRAY="[]"
if [[ -n "$REMOVE_LABELS" ]]; then
  IFS=',' read -ra REMOVE_IDS <<< "$REMOVE_LABELS"
  for LABEL in "${REMOVE_IDS[@]}"; do
    LABEL=$(echo "$LABEL" | xargs)  # Trim whitespace
    REMOVE_ARRAY=$(echo "$REMOVE_ARRAY" | jq --arg label "$LABEL" '. + [$label]')
  done
fi

# Build request body
REQUEST_BODY=$(jq -n \
  --argjson add "$ADD_ARRAY" \
  --argjson remove "$REMOVE_ARRAY" \
  '{
    addLabelIds: $add,
    removeLabelIds: $remove
  }')

# Modify labels
RESPONSE=$(curl -s -X POST \
  "https://gmail.googleapis.com/gmail/v1/users/me/messages/${MESSAGE_ID}/modify" \
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
