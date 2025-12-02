#!/bin/bash

# Get multiple Gmail threads in batch
# Usage: ./get-threads-batch.sh "user@example.com" "thread_id1,thread_id2,thread_id3"

set -euo pipefail

USER_EMAIL="$1"
THREAD_IDS="$2"  # Comma-separated list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Convert comma-separated list to array
IFS=',' read -ra IDS_ARRAY <<< "$THREAD_IDS"

# Build batch request (limit to 25 per batch to avoid SSL issues)
RESULTS="[]"

for THREAD_ID in "${IDS_ARRAY[@]}"; do
  THREAD_ID=$(echo "$THREAD_ID" | xargs)  # Trim whitespace

  # Get each thread
  THREAD=$("${SCRIPT_DIR}/get-thread.sh" "$USER_EMAIL" "$THREAD_ID")

  # Append to results
  RESULTS=$(echo "$RESULTS" | jq --argjson thread "$THREAD" '. + [$thread]')
done

# Return all threads
echo "$RESULTS" | jq '.'
