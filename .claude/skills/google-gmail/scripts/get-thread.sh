#!/bin/bash

# Get Gmail thread content
# Usage: ./get-thread.sh "user@example.com" "thread_id"

set -euo pipefail

USER_EMAIL="$1"
THREAD_ID="$2"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/mime.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Get thread
RESPONSE=$(curl -s \
  "https://gmail.googleapis.com/gmail/v1/users/me/threads/${THREAD_ID}?format=full" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Parse thread messages
MESSAGES=$(echo "$RESPONSE" | jq -r '.messages')
MESSAGE_COUNT=$(echo "$MESSAGES" | jq 'length')

PARSED_MESSAGES="[]"

for ((i=0; i<MESSAGE_COUNT; i++)); do
  MESSAGE=$(echo "$MESSAGES" | jq ".[$i]")

  # Extract headers
  HEADERS=$(echo "$MESSAGE" | jq '.payload.headers')
  FROM=$(extract_header "$HEADERS" "From")
  TO=$(extract_header "$HEADERS" "To")
  SUBJECT=$(extract_header "$HEADERS" "Subject")
  DATE=$(extract_header "$HEADERS" "Date")
  MESSAGE_ID=$(echo "$MESSAGE" | jq -r '.id')

  # Extract body
  PAYLOAD=$(echo "$MESSAGE" | jq '.payload')
  BODY=$(parse_mime_message "$PAYLOAD")

  # Build message object
  PARSED_MSG=$(jq -n \
    --arg id "$MESSAGE_ID" \
    --arg from "$FROM" \
    --arg to "$TO" \
    --arg subject "$SUBJECT" \
    --arg date "$DATE" \
    --arg body "$BODY" \
    '{
      id: $id,
      from: $from,
      to: $to,
      subject: $subject,
      date: $date,
      body: $body
    }')

  PARSED_MESSAGES=$(echo "$PARSED_MESSAGES" | jq --argjson msg "$PARSED_MSG" '. + [$msg]')
done

# Return thread with parsed messages
jq -n \
  --arg threadId "$THREAD_ID" \
  --argjson messages "$PARSED_MESSAGES" \
  '{
    threadId: $threadId,
    messageCount: ($messages | length),
    messages: $messages
  }'
