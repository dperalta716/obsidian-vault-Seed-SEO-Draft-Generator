#!/bin/bash
# config.sh - Shared configuration for academic-paper-research scripts
# Source this file from any script: source "$(dirname "$0")/config.sh"
#
# To set your email, either:
#   1. Set the ACADEMIC_RESEARCH_EMAIL environment variable
#   2. Or let it auto-detect from your git config
#
# The email is used for:
#   - CrossRef "polite pool" (better rate limits via User-Agent header)
#   - Unpaywall API identification (required query parameter)
# It's NOT used for login or authentication — just a contact for abuse reports.

CONTACT_EMAIL="${ACADEMIC_RESEARCH_EMAIL:-$(git config user.email 2>/dev/null || echo 'user@example.com')}"
