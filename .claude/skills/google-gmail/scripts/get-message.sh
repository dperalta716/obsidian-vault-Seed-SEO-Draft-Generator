#!/bin/bash

# Get Gmail message content
# Usage: ./get-message.sh "user@example.com" "message_id"

set -euo pipefail

USER_EMAIL="$1"
MESSAGE_ID="$2"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/mime.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Get message
RESPONSE=$(curl -s \
  "https://gmail.googleapis.com/gmail/v1/users/me/messages/${MESSAGE_ID}?format=full" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Extract headers
HEADERS=$(echo "$RESPONSE" | jq '.payload.headers')
FROM=$(extract_header "$HEADERS" "From")
TO=$(extract_header "$HEADERS" "To")
SUBJECT=$(extract_header "$HEADERS" "Subject")
DATE=$(extract_header "$HEADERS" "Date")

# Extract body
PAYLOAD=$(echo "$RESPONSE" | jq '.payload')
BODY=$(parse_mime_message "$PAYLOAD")

# Return formatted message
jq -n \
  --arg id "$MESSAGE_ID" \
  --arg from "$FROM" \
  --arg to "$TO" \
  --arg subject "$SUBJECT" \
  --arg date "$DATE" \
  --arg body "$BODY" \
  --argjson threadId "$(echo "$RESPONSE" | jq '.threadId')" \
  --argjson labels "$(echo "$RESPONSE" | jq '.labelIds')" \
  '{
    id: $id,
    threadId: $threadId,
    from: $from,
    to: $to,
    subject: $subject,
    date: $date,
    body: $body,
    labels: $labels
  }'
