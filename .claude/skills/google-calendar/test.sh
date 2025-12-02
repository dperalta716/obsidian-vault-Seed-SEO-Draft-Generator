#!/bin/bash

# Test all Calendar API operations
# Usage: ./test.sh [user_email]

USER_EMAIL="${1:-david@david-peralta.com}"
TODAY=$(date -u +"%Y-%m-%dT00:00:00Z")
TOMORROW=$(date -u -v+1d +"%Y-%m-%dT23:59:59Z")

echo "🧪 Testing Google Calendar Skill"
echo "=================================="
echo "User: $USER_EMAIL"
echo ""

# Change to script directory
cd "$(dirname "$0")/scripts"

# Test 1: List calendars
echo "1️⃣ Listing calendars..."
CALENDARS=$(./list-calendars.sh "$USER_EMAIL")
if echo "$CALENDARS" | jq -e '.error' > /dev/null 2>&1; then
  echo "❌ FAILED: $(echo "$CALENDARS" | jq -r '.error.message')"
  exit 1
fi
echo "✅ Found $(echo "$CALENDARS" | jq 'length') calendars"
echo "$CALENDARS" | jq '.[0:3] | .[] | {summary, id, primary}'
echo ""

# Test 2: Get today's events
echo "2️⃣ Getting today's events..."
EVENTS=$(./get-events.sh "$USER_EMAIL" "$TODAY" "$TOMORROW")
if echo "$EVENTS" | jq -e '.error' > /dev/null 2>&1; then
  echo "❌ FAILED: $(echo "$EVENTS" | jq -r '.error.message')"
  exit 1
fi
EVENT_COUNT=$(echo "$EVENTS" | jq 'length')
echo "✅ Found $EVENT_COUNT events today"
if [[ $EVENT_COUNT -gt 0 ]]; then
  echo "$EVENTS" | jq '.[0:3] | .[] | {summary, start: .start.dateTime, end: .end.dateTime}'
fi
echo ""

# Test 3: Create test event
echo "3️⃣ Creating test event..."
START_TIME=$(date -u -v+2H +"%Y-%m-%dT%H:00:00Z")
END_TIME=$(date -u -v+3H +"%Y-%m-%dT%H:00:00Z")
EVENT_JSON=$(./create-event.sh "$USER_EMAIL" "Test Event - Delete Me" "$START_TIME" "$END_TIME" "primary" "This is a test event created by the google-calendar skill test script")
if echo "$EVENT_JSON" | jq -e '.error' > /dev/null 2>&1; then
  echo "❌ FAILED: $(echo "$EVENT_JSON" | jq -r '.error.message')"
  exit 1
fi
EVENT_ID=$(echo "$EVENT_JSON" | jq -r '.id')
echo "✅ Created event: $EVENT_ID"
echo "$EVENT_JSON" | jq '{id, summary, start: .start.dateTime, end: .end.dateTime}'
echo ""

# Test 4: Modify event
echo "4️⃣ Modifying test event..."
MODIFIED_JSON=$(./modify-event.sh "$USER_EMAIL" "$EVENT_ID" "primary" "Test Event - MODIFIED" "" "" "" "Description updated by test script")
if echo "$MODIFIED_JSON" | jq -e '.error' > /dev/null 2>&1; then
  echo "❌ FAILED: $(echo "$MODIFIED_JSON" | jq -r '.error.message')"
  exit 1
fi
echo "✅ Modified event"
echo "$MODIFIED_JSON" | jq '{id, summary, description, updated}'
echo ""

# Test 5: Delete event
echo "5️⃣ Deleting test event..."
DELETE_RESULT=$(./delete-event.sh "$USER_EMAIL" "$EVENT_ID")
if echo "$DELETE_RESULT" | jq -e '.error' > /dev/null 2>&1; then
  echo "❌ FAILED: $(echo "$DELETE_RESULT" | jq -r '.error.message')"
  exit 1
fi
echo "✅ Deleted event: $EVENT_ID"
echo "$DELETE_RESULT" | jq '.'
echo ""

# Test 6: Quick Add event
echo "6️⃣ Testing QuickAdd..."
QUICKADD_TEXT="Coffee meeting tomorrow at 10am"
QUICKADD_JSON=$(./quick-add.sh "$USER_EMAIL" "$QUICKADD_TEXT")
if echo "$QUICKADD_JSON" | jq -e '.error' > /dev/null 2>&1; then
  echo "❌ FAILED: $(echo "$QUICKADD_JSON" | jq -r '.error.message')"
  exit 1
fi
QUICKADD_ID=$(echo "$QUICKADD_JSON" | jq -r '.id')
echo "✅ Created event via QuickAdd: $QUICKADD_ID"
echo "$QUICKADD_JSON" | jq '{id, summary, start: .start.dateTime, end: .end.dateTime}'
echo ""

# Cleanup QuickAdd test event
echo "🧹 Cleaning up QuickAdd test event..."
./delete-event.sh "$USER_EMAIL" "$QUICKADD_ID" > /dev/null 2>&1
echo ""

echo "✅ All Calendar API tests completed successfully!"
echo ""
echo "Summary:"
echo "  - Listed calendars: ✅"
echo "  - Retrieved events: ✅"
echo "  - Created event: ✅"
echo "  - Modified event: ✅"
echo "  - Deleted event: ✅"
echo "  - QuickAdd event: ✅"
