#!/bin/bash

# Quick Add Event - Create event using natural language
# Usage: ./quick-add.sh <user_email> <event_text> [calendar_id]
#
# Examples:
#   ./quick-add.sh david@david-peralta.com "Meeting with John tomorrow at 3pm"
#   ./quick-add.sh david@david-peralta.com "Lunch at noon on Friday"
#   ./quick-add.sh david@david-peralta.com "Dentist appointment next Tuesday 2pm"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/auth.sh"

# Parse arguments
USER_EMAIL="$1"
EVENT_TEXT="$2"
CALENDAR_ID="${3:-primary}"

# Validate required parameters
if [[ -z "$USER_EMAIL" || -z "$EVENT_TEXT" ]]; then
  echo '{"error": {"message": "Usage: quick-add.sh <user_email> <event_text> [calendar_id]"}}' >&2
  exit 1
fi

# Get access token
ACCESS_TOKEN=$(get_google_token "$USER_EMAIL")

# URL encode the event text
EVENT_TEXT_ENCODED=$(printf %s "$EVENT_TEXT" | jq -sRr @uri)

# URL encode calendar ID
CALENDAR_ID_ENCODED=$(printf %s "$CALENDAR_ID" | jq -sRr @uri)

# Call QuickAdd API
RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X POST \
  "https://www.googleapis.com/calendar/v3/calendars/${CALENDAR_ID_ENCODED}/events/quickAdd?text=${EVENT_TEXT_ENCODED}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json")

# Split response body and status code (macOS-compatible)
HTTP_BODY=$(echo "$RESPONSE" | sed '$d')
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

# Check for 401 (token expired) and retry with refreshed token
if [[ "$HTTP_CODE" == "401" ]]; then
  ACCESS_TOKEN=$(refresh_google_token "$USER_EMAIL")

  RESPONSE=$(curl -s -w "\n%{http_code}" \
    -X POST \
    "https://www.googleapis.com/calendar/v3/calendars/${CALENDAR_ID_ENCODED}/events/quickAdd?text=${EVENT_TEXT_ENCODED}" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H "Content-Type: application/json")

  HTTP_BODY=$(echo "$RESPONSE" | sed '$d')
  HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)
fi

# Check for errors
if [[ "$HTTP_CODE" != "200" ]]; then
  echo "$HTTP_BODY" | jq '.' >&2
  exit 1
fi

# Return the created event
echo "$HTTP_BODY" | jq '.'
