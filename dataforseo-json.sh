#!/bin/bash

# DataForSEO JSON Output Script
# Returns filtered JSON for parsing by Claude Code commands
# 
# Usage: ./dataforseo-json.sh "keyword" "language_code" "location"
# Example: ./dataforseo-json.sh "ultra processed foods" "en" "United States"

# Check if all arguments are provided
if [ $# -ne 3 ]; then
    echo '{"error": "Usage: '"$0"' \"keyword\" \"language_code\" \"location\""}'
    exit 1
fi

# DataForSEO API credentials
USERNAME="david@david-peralta.com"
PASSWORD="98fc1f9a4b87e200"

# Parameters
KEYWORD="$1"
LANGUAGE_CODE="$2"
LOCATION="$3"

# API endpoint (using .ai for token reduction)
ENDPOINT="https://api.dataforseo.com/v3/serp/google/organic/live/advanced.ai"

# Request payload
PAYLOAD="[{
    \"keyword\": \"$KEYWORD\",
    \"language_code\": \"$LANGUAGE_CODE\",
    \"location_name\": \"$LOCATION\",
    \"depth\": 10,
    \"people_also_ask_click_depth\": 2
}]"

# Make the API request and filter results to JSON
curl -s -u "$USERNAME:$PASSWORD" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$PAYLOAD" \
    "$ENDPOINT" | \
jq --arg keyword "$KEYWORD" --arg location "$LOCATION" --arg language "$LANGUAGE_CODE" '{
  keyword: $keyword,
  location: $location,
  language: $language,
  results: [
    .items[] | 
    select(.type == "organic" or 
           .type == "people_also_ask" or 
           .type == "related_searches" or 
           .type == "top_stories" or 
           .type == "ai_overview" or 
           .type == "discussions_and_forums" or 
           .type == "featured_snippet") |
    {
      type: .type,
      rank_absolute: .rank_absolute,
      title: .title,
      url: .url,
      domain: .domain,
      description: .description,
      items: .items,
      text: .text,
      source: .source
    }
  ]
}'