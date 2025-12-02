---
name: google-calendar
description: This skill should be used for Google Calendar operations including viewing events, creating meetings, and managing calendar entries. Use when user needs to check schedule, create events, organize calendar-related workflows, or integrate calendar data into daily todos and planning tasks.
---

# Google Calendar

## Overview

Provides access to Google Calendar API v3 for event management and calendar operations through bash scripts. This skill enables reading calendar events, creating meetings, modifying schedules, and deleting events without loading the full MCP tool definitions into context.

## When to Use This Skill

- Viewing today's or upcoming calendar events
- Creating new calendar events or meetings
- Quick event creation using natural language ("Meeting tomorrow at 3pm")
- Modifying existing events (time, location, attendees, description)
- Deleting calendar events
- Listing available calendars for a user
- Daily todo workflows that integrate calendar data
- Scheduling and time management tasks
- Any workflow requiring calendar event information

## Available Operations

### 1. List Calendars

Get all calendars accessible to the user.

**Script:** `scripts/list-calendars.sh`

**Usage:**
```bash
./scripts/list-calendars.sh "user@example.com"
```

**Returns:** JSON array of calendar objects with id, summary, and primary status.

**Example:**
```json
[
  {
    "id": "primary",
    "summary": "david@david-peralta.com",
    "primary": true
  },
  {
    "id": "work-calendar@group.calendar.google.com",
    "summary": "Work Calendar",
    "primary": false
  }
]
```

### 2. Get Events

Fetch events for a specific date range.

**Script:** `scripts/get-events.sh`

**Usage:**
```bash
./scripts/get-events.sh "user@example.com" "2025-10-23T00:00:00Z" "2025-10-23T23:59:59Z" [calendar_id]
```

**Parameters:**
- `user_email` (required): User's Google email address
- `time_min` (required): Start datetime in RFC3339 format (e.g., "2025-10-23T00:00:00Z")
- `time_max` (required): End datetime in RFC3339 format (e.g., "2025-10-23T23:59:59Z")
- `calendar_id` (optional): Calendar ID, defaults to "primary"

**Returns:** JSON array of event objects with summary, start/end times, location, attendees, and other event details.

**Example:**
```json
[
  {
    "id": "event123",
    "summary": "Team Standup",
    "start": {"dateTime": "2025-10-23T09:00:00-07:00"},
    "end": {"dateTime": "2025-10-23T09:30:00-07:00"},
    "location": "Conference Room A",
    "attendees": [
      {"email": "teammate@example.com"}
    ]
  }
]
```

**Common Use Cases:**
- Fetch today's events: Use today's date at 00:00:00Z to 23:59:59Z
- Fetch this week's events: Use Monday 00:00:00Z to Sunday 23:59:59Z
- Filter out "Blocked" events in post-processing if needed for daily todos

### 3. Create Event

Create a new calendar event.

**Script:** `scripts/create-event.sh`

**Usage:**
```bash
./scripts/create-event.sh "user@example.com" "Meeting Title" "2025-10-23T10:00:00" "2025-10-23T11:00:00" [calendar_id] [description] [location]
```

**Parameters:**
- `user_email` (required): User's Google email address
- `summary` (required): Event title/summary
- `start_time` (required): Start datetime (ISO 8601 format, e.g., "2025-10-23T10:00:00")
- `end_time` (required): End datetime (ISO 8601 format, e.g., "2025-10-23T11:00:00")
- `calendar_id` (optional): Calendar ID, defaults to "primary"
- `description` (optional): Event description
- `location` (optional): Event location

**Returns:** JSON object with created event details including event ID.

**Example:**
```bash
./scripts/create-event.sh "david@david-peralta.com" "Client Meeting" "2025-10-23T14:00:00" "2025-10-23T15:00:00" "primary" "Discuss Q4 goals" "Zoom"
```

### 4. Modify Event

Update an existing event's details.

**Script:** `scripts/modify-event.sh`

**Usage:**
```bash
./scripts/modify-event.sh "user@example.com" "event_id" [calendar_id] [new_summary] [new_start] [new_end] [new_location] [new_description]
```

**Parameters:**
- `user_email` (required): User's Google email address
- `event_id` (required): ID of the event to modify
- `calendar_id` (optional): Calendar ID, defaults to "primary"
- `new_summary` (optional): New event title
- `new_start` (optional): New start datetime
- `new_end` (optional): New end datetime
- `new_location` (optional): New location
- `new_description` (optional): New description

**Note:** The script fetches the current event first, then applies only the changes provided. Any parameter left empty will preserve the existing value.

**Returns:** JSON object with updated event details.

**Example:**
```bash
# Change only the time of an event
./scripts/modify-event.sh "david@david-peralta.com" "event123" "primary" "" "2025-10-23T15:00:00" "2025-10-23T16:00:00"
```

### 5. Delete Event

Remove a calendar event.

**Script:** `scripts/delete-event.sh`

**Usage:**
```bash
./scripts/delete-event.sh "user@example.com" "event_id" [calendar_id]
```

**Parameters:**
- `user_email` (required): User's Google email address
- `event_id` (required): ID of the event to delete
- `calendar_id` (optional): Calendar ID, defaults to "primary"

**Returns:** JSON success confirmation message.

**Example:**
```bash
./scripts/delete-event.sh "david@david-peralta.com" "event123"
```

### 6. Quick Add Event

Create a calendar event using natural language text. Google Calendar interprets the text to extract event details like date, time, location, and title.

**Script:** `scripts/quick-add.sh`

**Usage:**
```bash
./scripts/quick-add.sh "user@example.com" "event_text" [calendar_id]
```

**Parameters:**
- `user_email` (required): User's Google email address
- `event_text` (required): Natural language description of the event
- `calendar_id` (optional): Calendar ID, defaults to "primary"

**Returns:** JSON object with created event details including event ID.

**Examples:**
```bash
# Create a meeting for tomorrow
./scripts/quick-add.sh "david@david-peralta.com" "Meeting with John tomorrow at 3pm"

# Create a recurring lunch event
./scripts/quick-add.sh "david@david-peralta.com" "Lunch at noon on Friday"

# Create an appointment with location
./scripts/quick-add.sh "david@david-peralta.com" "Dentist appointment next Tuesday 2pm at 123 Main St"
```

**Supported Natural Language Patterns:**
- **Relative dates:** "tomorrow", "next Monday", "next week"
- **Absolute dates:** "October 25", "10/25", "Oct 25"
- **Times:** "at 3pm", "2:30pm", "14:00"
- **Duration:** "for 2 hours", "30 minutes"
- **Location:** Text after "at" is often interpreted as location

**Note:** Google's QuickAdd parser is intelligent but may not capture all details. For complex events with specific attendees, descriptions, or precise timing requirements, use the standard `create-event.sh` script instead.

## Authentication

All scripts automatically extract OAuth tokens from the independent credential store at `~/.claude/skills/google-workspace-credentials/` using the shared `scripts/lib/auth.sh` library. The authentication library:

- Extracts the access token from credential files at `~/.claude/skills/google-workspace-credentials/{user_email}.json`
- Provides automatic token refresh capability when access tokens expire
- Handles errors gracefully with descriptive JSON error messages
- Maintains complete independence from Google Workspace MCP server

**Requirements:**
- Credential file must exist at `~/.claude/skills/google-workspace-credentials/{user_email}.json`
- Credential file must contain:
  - `token` - OAuth access token (expires after ~1 hour)
  - `refresh_token` - Long-lived refresh token
  - `client_id` - OAuth client ID
  - `client_secret` - OAuth client secret
  - `token_uri` - Token refresh endpoint (usually Google's OAuth endpoint)
  - `scopes` - Authorized scopes (e.g., calendar, gmail, drive)
  - `expiry` - Token expiration timestamp

**Note:** This skill is completely independent from the Google Workspace MCP server and can function even if the MCP server is removed.

## Error Handling

All scripts return JSON error objects with descriptive messages when operations fail:

```json
{
  "error": {
    "message": "Description of what went wrong"
  }
}
```

Common errors:
- Missing or invalid OAuth tokens
- Event not found (invalid event ID)
- Invalid date/time formats
- Calendar access denied

## Integration Patterns

### Daily Todos Workflow

Fetch today's events and filter for specific patterns:

```bash
# Get today's events
EVENTS=$(./scripts/get-events.sh "david@david-peralta.com" "$(date -u +%Y-%m-%dT00:00:00Z)" "$(date -u +%Y-%m-%dT23:59:59Z)")

# Filter out "Blocked" calendar blockers
echo "$EVENTS" | jq '[.[] | select(.summary != "Blocked")]'
```

### Event Creation with Error Handling

```bash
RESULT=$(./scripts/create-event.sh "user@example.com" "Meeting" "2025-10-23T10:00:00" "2025-10-23T11:00:00" 2>&1)

if echo "$RESULT" | jq -e '.error' > /dev/null 2>&1; then
  echo "Failed to create event: $(echo "$RESULT" | jq -r '.error.message')"
else
  EVENT_ID=$(echo "$RESULT" | jq -r '.id')
  echo "Event created successfully: $EVENT_ID"
fi
```

## API Documentation

Full Google Calendar API v3 reference: https://developers.google.com/calendar/api/v3/reference

## Resources

### scripts/

Executable bash scripts for all calendar operations:
- `list-calendars.sh` - List all accessible calendars
- `get-events.sh` - Fetch events in date range
- `create-event.sh` - Create new event
- `quick-add.sh` - Create event using natural language
- `modify-event.sh` - Update existing event
- `delete-event.sh` - Delete event
- `lib/auth.sh` - Shared authentication library

All scripts are designed to be executed directly without loading into context, returning JSON output for easy parsing and integration into workflows.
