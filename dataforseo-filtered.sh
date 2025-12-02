#!/bin/bash

# DataForSEO Filtered SERP Fetcher
# Filters response to only include essential SERP types to avoid token limits
# Usage: ./dataforseo-filtered.sh "keyword" "language_code" "location"

KEYWORD="$1"
LANGUAGE="${2:-en}"
LOCATION="${3:-United States}"

if [ -z "$KEYWORD" ]; then
    echo "Error: Keyword required"
    echo "Usage: ./dataforseo-filtered.sh \"keyword\" \"language_code\" \"location\""
    exit 1
fi

# Read credentials from environment or prompt
if [ -z "$DATAFORSEO_USERNAME" ] || [ -z "$DATAFORSEO_PASSWORD" ]; then
    echo "Error: DataForSEO credentials not found in environment"
    echo "Set DATAFORSEO_USERNAME and DATAFORSEO_PASSWORD environment variables"
    exit 1
fi

# Create temporary JSON payload
TEMP_FILE=$(mktemp)
cat > "$TEMP_FILE" <<EOF
[{
    "keyword": "$KEYWORD",
    "location_name": "$LOCATION",
    "language_code": "$LANGUAGE",
    "depth": 10,
    "people_also_ask_click_depth": 2
}]
EOF

# Make API call and filter response with jq
curl -s --request POST \
    --url https://api.dataforseo.com/v3/serp/google/organic/live/advanced \
    --header 'content-type: application/json' \
    --user "${DATAFORSEO_USERNAME}:${DATAFORSEO_PASSWORD}" \
    --data @"$TEMP_FILE" | \
jq '[.tasks[0].result[0].items[] |
    select(.type == "organic" or
           .type == "people_also_ask" or
           .type == "related_searches" or
           .type == "top_stories" or
           .type == "ai_overview" or
           .type == "discussions_and_forums" or
           .type == "featured_snippet")]'

# Clean up
rm -f "$TEMP_FILE"
