#!/bin/bash

# Create a permission (share file) in Google Drive
# Usage: ./create-permission.sh "user@example.com" "file_id" "email_or_domain" "role" [type]

set -euo pipefail

USER_EMAIL="$1"
FILE_ID="$2"
EMAIL_OR_DOMAIN="$3"
ROLE="$4"
TYPE="${5:-user}"

# Validate role
if [[ ! "$ROLE" =~ ^(reader|writer|commenter|owner)$ ]]; then
  echo '{"error": {"message": "Invalid role. Must be: reader, writer, commenter, or owner"}}' >&2
  exit 1
fi

# Validate type
if [[ ! "$TYPE" =~ ^(user|group|domain|anyone)$ ]]; then
  echo '{"error": {"message": "Invalid type. Must be: user, group, domain, or anyone"}}' >&2
  exit 1
fi

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build request body based on type
if [[ "$TYPE" == "user" || "$TYPE" == "group" ]]; then
  REQUEST_BODY=$(jq -n \
    --arg type "$TYPE" \
    --arg role "$ROLE" \
    --arg email "$EMAIL_OR_DOMAIN" \
    '{type: $type, role: $role, emailAddress: $email}')
elif [[ "$TYPE" == "domain" ]]; then
  REQUEST_BODY=$(jq -n \
    --arg type "$TYPE" \
    --arg role "$ROLE" \
    --arg domain "$EMAIL_OR_DOMAIN" \
    '{type: $type, role: $role, domain: $domain}')
else  # anyone
  REQUEST_BODY=$(jq -n \
    --arg type "$TYPE" \
    --arg role "$ROLE" \
    '{type: $type, role: $role}')
fi

# Create permission
RESPONSE=$(curl -s -X POST \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}/permissions?fields=id,type,role,emailAddress,domain" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return created permission
echo "$RESPONSE" | jq '.'
