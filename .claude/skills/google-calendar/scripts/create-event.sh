#!/bin/bash

# Create a new calendar event
# Usage: ./create-event.sh "user@example.com" "Meeting Title" "2025-10-23T10:00:00" "2025-10-23T11:00:00" [calendar_id] [description] [location]

set -euo pipefail

USER_EMAIL="$1"
SUMMARY="$2"
START_TIME="$3"
END_TIME="$4"
CALENDAR_ID="${5:-primary}"
DESCRIPTION="${6:-}"
LOCATION="${7:-}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# Build event object
EVENT=$(jq -n \
  --arg summary "$SUMMARY" \
  --arg start "$START_TIME" \
  --arg end "$END_TIME" \
  --arg description "$DESCRIPTION" \
  --arg location "$LOCATION" \
  '{
    summary: $summary,
    start: {dateTime: $start},
    end: {dateTime: $end}
  } + (if $description != "" then {description: $description} else {} end)
    + (if $location != "" then {location: $location} else {} end)')

# URL encode the calendar ID
CALENDAR_ID_ENCODED=$(printf %s "$CALENDAR_ID" | jq -sRr @uri)

# Create event
RESPONSE=$(curl -s -X POST \
  "https://www.googleapis.com/calendar/v3/calendars/${CALENDAR_ID_ENCODED}/events" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$EVENT")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return created event
echo "$RESPONSE" | jq '.'
