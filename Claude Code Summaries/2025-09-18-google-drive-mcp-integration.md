---
tags: [type/reference, source/claude-code, topic/mcp, topic/google-drive, topic/oauth, client/seed, status/final]
date: 2025-09-18
session-topic: google-drive-mcp-integration
---

# Claude Code Session: Google Drive MCP Integration for SEO Draft Automation

**Date**: 2025-09-18
**Session Duration**: ~1.5 hours

## Problem/Challenge

The existing SEO draft upload workflow required manual intervention to move Google Docs from the root folder to a specific NPD drafts folder in Google Drive after creation. The goal was to automate this process by integrating a Google Drive MCP server that could create documents directly in specified folders, eliminating the manual organization step.

## Solution Summary

Successfully integrated the Piotr Agier Google Drive MCP server (`@piotr-agier/google-drive-mcp`) alongside the existing Google Workspace MCP. This provides the `createGoogleDoc` function with a `parentFolderId` parameter, allowing documents to be created directly in the NPD drafts folder (ID: `1JWFAoYKwsD2zTtypjs2gb34F0jAvv2bD`).

## Technical Implementation

### 1. MCP Server Installation
```bash
# Install the Google Drive MCP server with existing OAuth credentials
claude mcp add google-drive npx @piotr-agier/google-drive-mcp \
  --env GOOGLE_DRIVE_OAUTH_CREDENTIALS="/Users/david/Downloads/client_secret_2_918777191801-qrkinm674lchubfupi1vq03ohcin4vae.apps.googleusercontent.com.json"
```

### 2. OAuth Configuration Fix
- **Problem**: Initial authentication failed with `redirect_uri_mismatch` error
- **Root Cause**: The OAuth client was configured for `http://localhost:8000/oauth2callback` (Google Workspace MCP) but the Google Drive MCP uses `http://localhost:3000/oauth2callback`
- **Solution**: Added the new redirect URI to the Google Cloud Console OAuth client configuration

### 3. Authentication Process
```bash
# Manual authentication command to complete OAuth flow
GOOGLE_DRIVE_OAUTH_CREDENTIALS="/Users/david/Downloads/client_secret_2_918777191801-qrkinm674lchubfupi1vq03ohcin4vae.apps.googleusercontent.com.json" \
npx @piotr-agier/google-drive-mcp auth
```

### 4. Token Storage Location
- Tokens saved at: `/Users/david/.config/google-drive-mcp/tokens.json`
- Permissions: 0600 (secure, user-only access)

### 5. Available MCP Tools
The Google Drive MCP provides these key tools:
- `mcp__google-drive__createGoogleDoc` - Create docs with folder placement
- `mcp__google-drive__moveItem` - Move files between folders
- `mcp__google-drive__listFolder` - List folder contents
- `mcp__google-drive__createFolder` - Create new folders
- Plus formatting tools for Docs, Sheets, and Slides

### 6. Successful Test
Created test document directly in NPD drafts folder:
- Document ID: `1ZRblIWnwKs4iQxJXhZt-Qos6FGNFJX7oNxgV6-9dhSA`
- Successfully placed in folder: `1JWFAoYKwsD2zTtypjs2gb34F0jAvv2bD`

## Key Learnings

1. **OAuth Redirect URI Specificity**: Each MCP server may use different ports for OAuth callbacks. The Google Drive MCP uses port 3000, not 8000 or 8080.

2. **Credential Reusability**: The same Google Cloud OAuth credentials JSON file can be used for multiple MCP servers, but each may require different redirect URIs to be configured.

3. **Authentication Flow**:
   - First run triggers browser-based OAuth consent
   - Tokens are stored locally and auto-refresh
   - Claude must be restarted after initial authentication for tools to become available

4. **MCP Tool Naming Convention**: Tools are accessed with the pattern `mcp__[server-name]__[tool-name]`

5. **Multiple MCP Servers**: Can run multiple Google-related MCP servers simultaneously (Google Workspace MCP + Google Drive MCP) without conflicts

## Related Notes

- [[upload-to-gdocs]] - Original command implementation
- [[CLAUDE.md]] - SEO Draft Generator workflow documentation
- [[Google Workspace MCP Setup]] - If exists

## Follow-up Actions

1. Create `upload-to-gdocs-v2.md` command that uses the new `createGoogleDoc` function with folder placement
2. Test the complete workflow with a real SEO draft
3. Update documentation to reflect the new automated folder organization capability
4. Consider migrating other Google Drive operations to the new MCP server for consistency