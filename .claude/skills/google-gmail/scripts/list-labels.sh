#!/bin/bash

# List Gmail labels
# Usage: ./list-labels.sh "user@example.com"

set -euo pipefail

USER_EMAIL="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# List labels
RESPONSE=$(curl -s \
  "https://gmail.googleapis.com/gmail/v1/users/me/labels" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return labels
echo "$RESPONSE" | jq '.labels'
