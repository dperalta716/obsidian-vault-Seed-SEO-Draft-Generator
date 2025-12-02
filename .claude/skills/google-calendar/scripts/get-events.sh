#!/bin/bash

# Get events from Google Calendar
# Usage: ./get-events.sh "email@example.com" "2025-10-23T00:00:00Z" "2025-10-23T23:59:59Z" [calendar_id]

set -euo pipefail

USER_EMAIL="$1"
TIME_MIN="$2"
TIME_MAX="$3"
CALENDAR_ID="${4:-primary}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# URL encode the calendar ID and time parameters
CALENDAR_ID_ENCODED=$(printf %s "$CALENDAR_ID" | jq -sRr @uri)
TIME_MIN_ENCODED=$(printf %s "$TIME_MIN" | jq -sRr @uri)
TIME_MAX_ENCODED=$(printf %s "$TIME_MAX" | jq -sRr @uri)

# Fetch events
RESPONSE=$(curl -s \
  "https://www.googleapis.com/calendar/v3/calendars/${CALENDAR_ID_ENCODED}/events?timeMin=${TIME_MIN_ENCODED}&timeMax=${TIME_MAX_ENCODED}&singleEvents=true&orderBy=startTime" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return events
echo "$RESPONSE" | jq '.items'
