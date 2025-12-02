#!/bin/bash

# List all permissions for a Google Drive file
# Usage: ./list-permissions.sh "user@example.com" "file_id"

set -euo pipefail

USER_EMAIL="$1"
FILE_ID="$2"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Get permissions
RESPONSE=$(curl -s \
  "https://www.googleapis.com/drive/v3/files/${FILE_ID}/permissions?fields=permissions(id,type,role,emailAddress,domain,displayName)" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return permissions
echo "$RESPONSE" | jq '.permissions'
