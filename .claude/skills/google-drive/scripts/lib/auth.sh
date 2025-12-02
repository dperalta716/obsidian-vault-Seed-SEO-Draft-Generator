#!/bin/bash

# Shared authentication library for Google API scripts
# Extracts OAuth tokens from Claude skills credential store
# INDEPENDENT from Google Workspace MCP server

get_credential_file() {
  local USER_EMAIL="$1"
  local CREDS_DIR="${HOME}/.claude/skills/google-workspace-credentials"
  local CREDS_FILE="${CREDS_DIR}/${USER_EMAIL}.json"

  if [[ ! -f "$CREDS_FILE" ]]; then
    echo '{"error": {"message": "Credential file not found at '"$CREDS_FILE"'. Credentials should be in ~/.claude/skills/google-workspace-credentials/"}}' >&2
    exit 1
  fi

  echo "$CREDS_FILE"
}

get_google_token() {
  local USER_EMAIL="${1:-david@david-peralta.com}"
  local CREDS_FILE=$(get_credential_file "$USER_EMAIL")

  # Extract access token
  local ACCESS_TOKEN=$(jq -r '.token // empty' "$CREDS_FILE")

  if [[ -z "$ACCESS_TOKEN" ]]; then
    echo '{"error": {"message": "Access token not found in credential file"}}' >&2
    exit 1
  fi

  echo "$ACCESS_TOKEN"
}

get_google_refresh_token() {
  local USER_EMAIL="${1:-david@david-peralta.com}"
  local CREDS_FILE=$(get_credential_file "$USER_EMAIL")
  jq -r '.refresh_token // empty' "$CREDS_FILE"
}

get_google_client_id() {
  local USER_EMAIL="${1:-david@david-peralta.com}"
  local CREDS_FILE=$(get_credential_file "$USER_EMAIL")
  jq -r '.client_id // empty' "$CREDS_FILE"
}

get_google_client_secret() {
  local USER_EMAIL="${1:-david@david-peralta.com}"
  local CREDS_FILE=$(get_credential_file "$USER_EMAIL")
  jq -r '.client_secret // empty' "$CREDS_FILE"
}

get_token_uri() {
  local USER_EMAIL="${1:-david@david-peralta.com}"
  local CREDS_FILE=$(get_credential_file "$USER_EMAIL")
  jq -r '.token_uri // empty' "$CREDS_FILE"
}

# Refresh access token if expired
refresh_google_token() {
  local USER_EMAIL="${1:-david@david-peralta.com}"
  local CREDS_FILE=$(get_credential_file "$USER_EMAIL")

  local REFRESH_TOKEN=$(get_google_refresh_token "$USER_EMAIL")
  local CLIENT_ID=$(get_google_client_id "$USER_EMAIL")
  local CLIENT_SECRET=$(get_google_client_secret "$USER_EMAIL")
  local TOKEN_URI=$(get_token_uri "$USER_EMAIL")

  if [[ -z "$REFRESH_TOKEN" || -z "$CLIENT_ID" || -z "$CLIENT_SECRET" ]]; then
    echo '{"error": {"message": "Missing OAuth credentials for token refresh"}}' >&2
    exit 1
  fi

  # Use token_uri from credentials, or default to Google's endpoint
  TOKEN_URI="${TOKEN_URI:-https://oauth2.googleapis.com/token}"

  # Call Google's token refresh endpoint
  local RESPONSE=$(curl -s -X POST "$TOKEN_URI" \
    -d "client_id=${CLIENT_ID}" \
    -d "client_secret=${CLIENT_SECRET}" \
    -d "refresh_token=${REFRESH_TOKEN}" \
    -d "grant_type=refresh_token")

  local NEW_TOKEN=$(echo "$RESPONSE" | jq -r '.access_token // empty')

  if [[ -z "$NEW_TOKEN" ]]; then
    echo "$RESPONSE" | jq '.error' >&2
    exit 1
  fi

  # Update credential file with new token
  local UPDATED_CREDS=$(jq \
    --arg token "$NEW_TOKEN" \
    '.token = $token' \
    "$CREDS_FILE")

  echo "$UPDATED_CREDS" > "$CREDS_FILE"
  echo "$NEW_TOKEN"
}
