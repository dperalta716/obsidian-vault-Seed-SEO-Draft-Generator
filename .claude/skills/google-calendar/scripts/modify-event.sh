#!/bin/bash

# Modify an existing calendar event
# Usage: ./modify-event.sh "user@example.com" "event_id" [calendar_id] [new_summary] [new_start] [new_end] [new_location] [new_description]

set -euo pipefail

USER_EMAIL="$1"
EVENT_ID="$2"
CALENDAR_ID="${3:-primary}"
NEW_SUMMARY="${4:-}"
NEW_START="${5:-}"
NEW_END="${6:-}"
NEW_LOCATION="${7:-}"
NEW_DESCRIPTION="${8:-}"

# Source authentication helper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Get OAuth token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# URL encode the calendar ID and event ID
CALENDAR_ID_ENCODED=$(printf %s "$CALENDAR_ID" | jq -sRr @uri)
EVENT_ID_ENCODED=$(printf %s "$EVENT_ID" | jq -sRr @uri)

# First, get the current event
CURRENT_EVENT=$(curl -s \
  "https://www.googleapis.com/calendar/v3/calendars/${CALENDAR_ID_ENCODED}/events/${EVENT_ID_ENCODED}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")

# Check for errors
if echo "$CURRENT_EVENT" | jq -e '.error' > /dev/null 2>&1; then
  echo "$CURRENT_EVENT" | jq '.error' >&2
  exit 1
fi

# Build updated event object, keeping existing values if not provided
UPDATED_EVENT=$(echo "$CURRENT_EVENT" | jq \
  --arg summary "$NEW_SUMMARY" \
  --arg start "$NEW_START" \
  --arg end "$NEW_END" \
  --arg location "$NEW_LOCATION" \
  --arg description "$NEW_DESCRIPTION" \
  '
  . + (if $summary != "" then {summary: $summary} else {} end)
    + (if $start != "" then {start: {dateTime: $start}} else {} end)
    + (if $end != "" then {end: {dateTime: $end}} else {} end)
    + (if $location != "" then {location: $location} else {} end)
    + (if $description != "" then {description: $description} else {} end)
  ')

# Update event
RESPONSE=$(curl -s -X PUT \
  "https://www.googleapis.com/calendar/v3/calendars/${CALENDAR_ID_ENCODED}/events/${EVENT_ID_ENCODED}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$UPDATED_EVENT")

# Check for errors
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Return updated event
echo "$RESPONSE" | jq '.'
