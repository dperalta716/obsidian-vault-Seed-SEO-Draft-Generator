#!/bin/bash

# Manage Gmail labels (create, update, delete)
# Usage: ./manage-label.sh "user@example.com" "action" "name" [label_id] [visibility] [list_visibility]

set -euo pipefail

USER_EMAIL="$1"
ACTION="$2"  # create, update, delete
NAME="${3:-}"
LABEL_ID="${4:-}"
MSG_LIST_VISIBILITY="${5:-show}"  # show or hide
LABEL_LIST_VISIBILITY="${6:-labelShow}"  # labelShow or labelHide

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

case "$ACTION" in
  create)
    if [[ -z "$NAME" ]]; then
      echo '{"error": {"message": "Label name required for create action"}}' >&2
      exit 1
    fi

    # Create label
    REQUEST_BODY=$(jq -n \
      --arg name "$NAME" \
      --arg msgVis "$MSG_LIST_VISIBILITY" \
      --arg labelVis "$LABEL_LIST_VISIBILITY" \
      '{
        name: $name,
        messageListVisibility: $msgVis,
        labelListVisibility: $labelVis
      }')

    RESPONSE=$(curl -s -X POST \
      "https://gmail.googleapis.com/gmail/v1/users/me/labels" \
      -H "Authorization: Bearer ${ACCESS_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "$REQUEST_BODY")
    ;;

  update)
    if [[ -z "$LABEL_ID" ]]; then
      echo '{"error": {"message": "Label ID required for update action"}}' >&2
      exit 1
    fi

    # Build update body
    REQUEST_BODY=$(jq -n \
      --arg name "${NAME:-}" \
      --arg msgVis "$MSG_LIST_VISIBILITY" \
      --arg labelVis "$LABEL_LIST_VISIBILITY" \
      '{
        messageListVisibility: $msgVis,
        labelListVisibility: $labelVis
      } + (if $name != "" then {name: $name} else {} end)')

    RESPONSE=$(curl -s -X PATCH \
      "https://gmail.googleapis.com/gmail/v1/users/me/labels/${LABEL_ID}" \
      -H "Authorization: Bearer ${ACCESS_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "$REQUEST_BODY")
    ;;

  delete)
    if [[ -z "$LABEL_ID" ]]; then
      echo '{"error": {"message": "Label ID required for delete action"}}' >&2
      exit 1
    fi

    # Delete label
    RESPONSE=$(curl -s -X DELETE \
      "https://gmail.googleapis.com/gmail/v1/users/me/labels/${LABEL_ID}" \
      -H "Authorization: Bearer ${ACCESS_TOKEN}")

    # Return success message
    if [[ -z "$RESPONSE" ]]; then
      echo '{"success": true, "message": "Label deleted successfully"}'
      exit 0
    fi
    ;;

  *)
    echo '{"error": {"message": "Invalid action. Use: create, update, or delete"}}' >&2
    exit 1
    ;;
esac

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return response
echo "$RESPONSE" | jq '.'
