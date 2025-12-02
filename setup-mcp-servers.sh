#!/bin/bash
# Auto-setup MCP servers for new Seed-SEO-Draft-Generator versions
# This script automatically detects the current version and copies MCP configuration from the previous version

set -e  # Exit on error

echo "🔧 Setting up MCP servers for Seed-SEO-Draft-Generator..."
echo ""

# Get the current directory name and extract version number
CURRENT_DIR=$(basename "$PWD")
PARENT_DIR=$(dirname "$PWD")

# Extract version number (e.g., "v4" from "Seed-SEO-Draft-Generator-v4")
if [[ $CURRENT_DIR =~ Seed-SEO-Draft-Generator-v([0-9]+) ]]; then
    CURRENT_VERSION=${BASH_REMATCH[1]}
    echo "✓ Detected current version: v$CURRENT_VERSION"
else
    echo "❌ Error: Could not detect version number from directory name: $CURRENT_DIR"
    echo "   Expected format: Seed-SEO-Draft-Generator-v{number}"
    exit 1
fi

# Calculate previous version number
PREVIOUS_VERSION=$((CURRENT_VERSION - 1))

# Construct paths
CURRENT_PATH="$PWD"
PREVIOUS_PATH="$PARENT_DIR/Seed-SEO-Draft-Generator-v$PREVIOUS_VERSION"
CLAUDE_CODE_DEMO_PATH="$PARENT_DIR"

echo "✓ Looking for previous version: v$PREVIOUS_VERSION"
echo "  Path: $PREVIOUS_PATH"

# Check if previous version exists
if [ ! -d "$PREVIOUS_PATH" ]; then
    echo "❌ Error: Previous version directory not found: $PREVIOUS_PATH"
    echo "   Cannot copy MCP configuration without a previous version."
    exit 1
fi

echo "✓ Found previous version directory"
echo ""
echo "📋 Copying MCP server configuration..."

# Run Python script to update .claude.json
python3 << EOF
import json
import sys

try:
    # Read current config
    claude_json_path = '/Users/david/.claude.json'
    with open(claude_json_path, 'r') as f:
        data = json.load(f)

    # Paths
    previous_path = "$PREVIOUS_PATH"
    current_path = "$CURRENT_PATH"
    parent_path = "$CLAUDE_CODE_DEMO_PATH"

    print(f"  Source (v$PREVIOUS_VERSION): {previous_path}")
    print(f"  Destination (v$CURRENT_VERSION): {current_path}")
    print(f"  Parent (for dfs-mcp-ai): {parent_path}")
    print()

    # Get MCP servers from previous version
    previous_mcp = data['projects'].get(previous_path, {}).get('mcpServers', {})

    if not previous_mcp:
        print(f"⚠️  Warning: No MCP servers found in v$PREVIOUS_VERSION")
        print(f"   Will try to get configuration from parent directory instead")

    # Get dfs-mcp-ai from parent directory (it's usually here)
    parent_mcp = data['projects'].get(parent_path, {}).get('mcpServers', {})
    dfs_mcp_ai = parent_mcp.get('dfs-mcp-ai')

    # Initialize current version in projects if needed
    if current_path not in data['projects']:
        data['projects'][current_path] = {}

    # Initialize mcpServers
    if 'mcpServers' not in data['projects'][current_path]:
        data['projects'][current_path]['mcpServers'] = {}

    # Copy all servers from previous version
    data['projects'][current_path]['mcpServers'].update(previous_mcp)

    # Ensure dfs-mcp-ai is present (from parent if not in previous)
    if 'dfs-mcp-ai' not in data['projects'][current_path]['mcpServers'] and dfs_mcp_ai:
        data['projects'][current_path]['mcpServers']['dfs-mcp-ai'] = dfs_mcp_ai

    # Write back to file
    with open(claude_json_path, 'w') as f:
        json.dump(data, f, indent=2)

    # Report configured servers
    configured_servers = list(data['projects'][current_path]['mcpServers'].keys())

    if configured_servers:
        print("✅ Successfully configured MCP servers:")
        for server_name in configured_servers:
            print(f"   • {server_name}")
    else:
        print("⚠️  No MCP servers were configured!")
        sys.exit(1)

except Exception as e:
    print(f"❌ Error: {str(e)}")
    sys.exit(1)
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ MCP server setup complete!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Exit Claude Code if it's running: /exit"
    echo "   2. Start Claude Code in this directory: claude"
    echo "   3. Verify with: /mcp"
    echo ""
else
    echo ""
    echo "❌ Setup failed. Please check the error messages above."
    exit 1
fi
