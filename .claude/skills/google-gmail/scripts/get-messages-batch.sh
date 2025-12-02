#!/bin/bash

# Get multiple Gmail messages in batch
# Usage: ./get-messages-batch.sh "user@example.com" "message_id1,message_id2,message_id3"

set -euo pipefail

USER_EMAIL="$1"
MESSAGE_IDS="$2"  # Comma-separated list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Convert comma-separated list to array
IFS=',' read -ra IDS_ARRAY <<< "$MESSAGE_IDS"

# Build batch request (limit to 25 per batch to avoid SSL issues)
RESULTS="[]"

for MESSAGE_ID in "${IDS_ARRAY[@]}"; do
  MESSAGE_ID=$(echo "$MESSAGE_ID" | xargs)  # Trim whitespace

  # Get each message
  MESSAGE=$("${SCRIPT_DIR}/get-message.sh" "$USER_EMAIL" "$MESSAGE_ID")

  # Append to results
  RESULTS=$(echo "$RESULTS" | jq --argjson msg "$MESSAGE" '. + [$msg]')
done

# Return all messages
echo "$RESULTS" | jq '.'
