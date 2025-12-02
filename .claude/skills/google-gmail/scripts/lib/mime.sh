#!/bin/bash

# MIME message encoding/decoding for Gmail API

# Create MIME message for sending
create_mime_message() {
  local FROM="$1"
  local TO="$2"
  local SUBJECT="$3"
  local BODY="$4"
  local CC="${5:-}"
  local BCC="${6:-}"
  local IN_REPLY_TO="${7:-}"
  local REFERENCES="${8:-}"

  # Extract display name from email if not provided
  # Format: "Display Name <email@example.com>" or just "email@example.com"
  local FROM_HEADER
  if [[ "$FROM" == *"<"*">"* ]]; then
    # Already has display name format
    FROM_HEADER="$FROM"
  else
    # Just email address - extract name from local part
    local EMAIL_LOCAL="${FROM%%@*}"
    # Capitalize first letter and convert to Title Case
    local DISPLAY_NAME=$(echo "$EMAIL_LOCAL" | sed 's/\./ /g' | sed 's/\b\(.\)/\u\1/g')
    FROM_HEADER="${DISPLAY_NAME} <${FROM}>"
  fi

  # Build MIME message with proper CRLF line endings
  local MIME=$'From: '"${FROM_HEADER}"$'\r\n'
  MIME+=$'To: '"${TO}"$'\r\n'
  [[ -n "$CC" ]] && MIME+=$'Cc: '"${CC}"$'\r\n'
  [[ -n "$BCC" ]] && MIME+=$'Bcc: '"${BCC}"$'\r\n'
  MIME+=$'Subject: '"${SUBJECT}"$'\r\n'
  [[ -n "$IN_REPLY_TO" ]] && MIME+=$'In-Reply-To: '"${IN_REPLY_TO}"$'\r\n'
  [[ -n "$REFERENCES" ]] && MIME+=$'References: '"${REFERENCES}"$'\r\n'
  MIME+=$'\r\n'
  MIME+="${BODY}"

  # Base64url encode (Gmail API requirement)
  echo -n "$MIME" | base64 | tr '+/' '-_' | tr -d '=' | tr -d '\n'
}

# Parse MIME message from Gmail API response
parse_mime_message() {
  local PAYLOAD="$1"

  # Extract parts (simplified - handles both single-part and multipart messages)
  local BODY=$(echo "$PAYLOAD" | jq -r '.body.data // .parts[0].body.data // .parts[] | select(.mimeType == "text/plain") | .body.data // empty' | head -n 1)

  if [[ -z "$BODY" || "$BODY" == "null" ]]; then
    # Try to get HTML content if plain text not available
    BODY=$(echo "$PAYLOAD" | jq -r '.parts[] | select(.mimeType == "text/html") | .body.data // empty' | head -n 1)
  fi

  # Base64url decode if we got content
  if [[ -n "$BODY" && "$BODY" != "null" ]]; then
    echo "$BODY" | tr '_-' '/+' | base64 -d 2>/dev/null || echo "(Unable to decode message body)"
  else
    echo "(No readable message body found)"
  fi
}

# Extract email headers from message
extract_header() {
  local HEADERS="$1"
  local HEADER_NAME="$2"

  echo "$HEADERS" | jq -r --arg name "$HEADER_NAME" '.[] | select(.name == $name) | .value'
}
