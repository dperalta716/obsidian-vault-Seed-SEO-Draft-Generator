# Google Calendar Skill

This skill provides Google Calendar API v3 integration through bash scripts, enabling calendar operations without loading MCP tool definitions into context.

## Purpose

Replace Google Workspace MCP calendar tools with lightweight bash scripts that:
- Reduce context usage (from ~4,200 tokens to ~150 tokens in skill metadata)
- Load full instructions only when calendar operations are needed
- Provide identical functionality to MCP tools with direct API access

## Key Features

- **List Calendars**: Fetch all accessible calendars for a user
- **Get Events**: Retrieve events for specific date ranges
- **Create Events**: Add new calendar events with details
- **Modify Events**: Update existing event properties
- **Delete Events**: Remove calendar events
- **OAuth Authentication**: Automatic token extraction from MCP config
- **Error Handling**: Descriptive JSON error messages
- **Token Refresh**: Automatic handling of expired access tokens

## How to Use

### Running Scripts Manually

All scripts are in the `scripts/` directory and accept command-line arguments:

```bash
# List calendars
./scripts/list-calendars.sh "user@example.com"

# Get today's events
./scripts/get-events.sh "user@example.com" "2025-10-23T00:00:00Z" "2025-10-23T23:59:59Z"

# Create an event
./scripts/create-event.sh "user@example.com" "Meeting Title" "2025-10-23T10:00:00" "2025-10-23T11:00:00"

# Modify an event
./scripts/modify-event.sh "user@example.com" "event_id" "primary" "New Title"

# Delete an event
./scripts/delete-event.sh "user@example.com" "event_id"
```

### Using in Claude Code

When the skill is triggered, Claude automatically has access to all scripts and can execute them:

```bash
# Example: Fetch today's events for daily todos
EVENTS=$(./scripts/get-events.sh "david@david-peralta.com" "$(date -u +%Y-%m-%dT00:00:00Z)" "$(date -u +%Y-%m-%dT23:59:59Z)")

# Parse and use the JSON response
echo "$EVENTS" | jq '.[] | {summary, start: .start.dateTime}'
```

## Dependencies

### Required Tools
- `bash` - Shell scripting
- `curl` - HTTP requests to Google Calendar API
- `jq` - JSON parsing and manipulation

### Authentication Requirements
- Google Workspace MCP server configured with OAuth credentials
- Valid tokens in `~/.claude.json` at:
  - `mcpServers.google-workspace.env.GOOGLE_OAUTH_ACCESS_TOKEN`
  - `mcpServers.google-workspace.env.GOOGLE_OAUTH_REFRESH_TOKEN`
  - `mcpServers.google-workspace.env.GOOGLE_OAUTH_CLIENT_ID`
  - `mcpServers.google-workspace.env.GOOGLE_OAUTH_CLIENT_SECRET`

## Testing

Run the comprehensive test suite:

```bash
./test.sh [user_email]
```

Default email: `david@david-peralta.com`

The test script validates:
1. Listing calendars
2. Fetching events
3. Creating events
4. Modifying events
5. Deleting events

Expected output: All tests passing with ✅ indicators

## Tips & Best Practices

### Date/Time Formatting
- Use RFC3339 format for event queries: `2025-10-23T00:00:00Z`
- Use ISO 8601 for event creation: `2025-10-23T10:00:00`
- Always include timezone or use UTC (Z suffix)

### Error Handling
All scripts return JSON. Check for errors:

```bash
RESULT=$(./scripts/get-events.sh "user@example.com" "$START" "$END")
if echo "$RESULT" | jq -e '.error' > /dev/null 2>&1; then
  echo "Error: $(echo "$RESULT" | jq -r '.error.message')"
  exit 1
fi
```

### Integration Patterns

**Daily Todos Workflow:**
```bash
# Get today's events, excluding calendar blockers
EVENTS=$(./scripts/get-events.sh "$EMAIL" "$TODAY_START" "$TODAY_END")
REAL_EVENTS=$(echo "$EVENTS" | jq '[.[] | select(.summary != "Blocked")]')
```

**Event Creation with Validation:**
```bash
# Create event and capture ID for later use
EVENT=$(./scripts/create-event.sh "$EMAIL" "$TITLE" "$START" "$END" "primary" "$DESC" "$LOC")
EVENT_ID=$(echo "$EVENT" | jq -r '.id')
echo "Created event: $EVENT_ID"
```

### Token Management
- Access tokens expire after ~1 hour
- Scripts automatically attempt token refresh on 401 errors
- Refresh tokens are long-lived but can be revoked
- If authentication fails completely, re-run MCP server OAuth flow

## Common Issues

**"MCP config not found"**
- Ensure `~/.claude.json` exists
- Verify Google Workspace MCP server is installed

**"Google OAuth token not found"**
- Check MCP server configuration includes OAuth credentials
- May need to re-authenticate with MCP server

**"Invalid date/time format"**
- Use RFC3339 format: `YYYY-MM-DDTHH:MM:SSZ`
- Include timezone or use UTC

**"Event not found"**
- Verify event ID is correct
- Check you're querying the correct calendar
- Event may have been deleted

## File Structure

```
google-calendar/
├── SKILL.md                    # Skill definition and instructions
├── README.md                   # This file
├── test.sh                     # Test suite
└── scripts/
    ├── list-calendars.sh       # List all calendars
    ├── get-events.sh           # Fetch events
    ├── create-event.sh         # Create new event
    ├── modify-event.sh         # Update existing event
    ├── delete-event.sh         # Delete event
    └── lib/
        └── auth.sh             # Shared OAuth authentication
```

## API Reference

Full Google Calendar API documentation:
https://developers.google.com/calendar/api/v3/reference

## Part of MCP Conversion Plan

This skill is Phase 1 of the Google Workspace MCP to Skills conversion:
- **Current**: 51 MCP tools consuming 42.4k tokens
- **Target**: 5 skills consuming ~750 tokens (98% reduction)
- **This Skill**: Replaces 6 calendar MCP tools, saving ~4,200 tokens

See: `Claude Code Summaries/2025-10-23-google-workspace-mcp-to-skills-conversion-plan.md`
