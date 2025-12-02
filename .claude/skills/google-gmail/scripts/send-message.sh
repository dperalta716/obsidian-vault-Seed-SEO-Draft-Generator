#!/bin/bash

# Send email via Gmail API
# Usage: ./send-message.sh "user@example.com" "to@example.com" "Subject" "Body" [cc] [bcc] [thread_id] [in_reply_to] [references] [from_name]

set -euo pipefail

USER_EMAIL="$1"
TO="$2"
SUBJECT="$3"
BODY="$4"
CC="${5:-}"
BCC="${6:-}"
THREAD_ID="${7:-}"
IN_REPLY_TO="${8:-}"
REFERENCES="${9:-}"
FROM_NAME="${10:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"
source "${SCRIPT_DIR}/lib/mime.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Create MIME message with optional display name
if [[ -n "$FROM_NAME" ]]; then
  FROM_FIELD="${FROM_NAME} <${USER_EMAIL}>"
else
  FROM_FIELD="$USER_EMAIL"
fi

ENCODED_MESSAGE=$(create_mime_message "$FROM_FIELD" "$TO" "$SUBJECT" "$BODY" "$CC" "$BCC" "$IN_REPLY_TO" "$REFERENCES")

# Build request body
if [[ -n "$THREAD_ID" ]]; then
  REQUEST_BODY=$(jq -n \
    --arg raw "$ENCODED_MESSAGE" \
    --arg threadId "$THREAD_ID" \
    '{raw: $raw, threadId: $threadId}')
else
  REQUEST_BODY=$(jq -n \
    --arg raw "$ENCODED_MESSAGE" \
    '{raw: $raw}')
fi

# Send message
RESPONSE=$(curl -s -X POST \
  "https://gmail.googleapis.com/gmail/v1/users/me/messages/send" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return message details
echo "$RESPONSE" | jq '.'
