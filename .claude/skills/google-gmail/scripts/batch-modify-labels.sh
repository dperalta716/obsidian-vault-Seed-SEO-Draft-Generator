#!/bin/bash

# Batch modify labels on multiple Gmail messages
# Usage: ./batch-modify-labels.sh "user@example.com" "message_id1,message_id2,message_id3" "add_label_ids" "remove_label_ids"

set -euo pipefail

USER_EMAIL="$1"
MESSAGE_IDS="$2"  # Comma-separated list
ADD_LABELS="${3:-}"  # Comma-separated list
REMOVE_LABELS="${4:-}"  # Comma-separated list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Convert comma-separated lists to JSON arrays
MSG_ARRAY="[]"
IFS=',' read -ra MSG_IDS <<< "$MESSAGE_IDS"
for MSG_ID in "${MSG_IDS[@]}"; do
  MSG_ID=$(echo "$MSG_ID" | xargs)  # Trim whitespace
  MSG_ARRAY=$(echo "$MSG_ARRAY" | jq --arg id "$MSG_ID" '. + [$id]')
done

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
  --argjson ids "$MSG_ARRAY" \
  --argjson add "$ADD_ARRAY" \
  --argjson remove "$REMOVE_ARRAY" \
  '{
    ids: $ids,
    addLabelIds: $add,
    removeLabelIds: $remove
  }')

# Batch modify labels
RESPONSE=$(curl -s -X POST \
  "https://gmail.googleapis.com/gmail/v1/users/me/messages/batchModify" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return success (batchModify returns empty on success)
if [[ -z "$RESPONSE" || "$RESPONSE" == "{}" ]]; then
  jq -n \
    --argjson count "$(echo "$MSG_ARRAY" | jq 'length')" \
    '{
      success: true,
      messagesModified: $count
    }'
else
  echo "$RESPONSE" | jq '.'
fi
