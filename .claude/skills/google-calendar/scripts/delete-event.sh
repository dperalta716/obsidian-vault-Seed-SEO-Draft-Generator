#!/bin/bash

# Delete a calendar event
# Usage: ./delete-event.sh "user@example.com" "event_id" [calendar_id]

set -euo pipefail

USER_EMAIL="$1"
EVENT_ID="$2"
CALENDAR_ID="${3:-primary}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# URL encode the calendar ID and event ID
CALENDAR_ID_ENCODED=$(printf %s "$CALENDAR_ID" | jq -sRr @uri)
EVENT_ID_ENCODED=$(printf %s "$EVENT_ID" | jq -sRr @uri)

# Delete event
RESPONSE=$(curl -s -X DELETE \
  "https://www.googleapis.com/calendar/v3/calendars/${CALENDAR_ID_ENCODED}/events/${EVENT_ID_ENCODED}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -w "\n%{http_code}")

# Extract HTTP status code
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

# Check status code (204 = success for DELETE)
if [[ "$HTTP_CODE" == "204" ]]; then
  echo '{"success": true, "message": "Event deleted successfully"}'
  exit 0
fi

# Handle errors
if [[ -n "$BODY" ]]; then
  ERROR=$(echo "$BODY" | jq -e '.error')
  if [[ $? -eq 0 ]]; then
    echo "$ERROR" >&2
    exit 1
  fi
fi

echo "{\"error\": {\"message\": \"Delete failed with status code $HTTP_CODE\"}}" >&2
exit 1
