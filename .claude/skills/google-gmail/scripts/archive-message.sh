#!/bin/bash

# Archive Gmail message (remove from INBOX)
# Usage: ./archive-message.sh "user@example.com" "message_id"

set -euo pipefail

USER_EMAIL="$1"
MESSAGE_ID="$2"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Archive is just removing the INBOX label
"${SCRIPT_DIR}/modify-message-labels.sh" "$USER_EMAIL" "$MESSAGE_ID" "" "INBOX"
