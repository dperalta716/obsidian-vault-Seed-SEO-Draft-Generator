#!/bin/bash

# Install script for SEO Content Generator output style
# This makes the output style available globally for all Claude Code projects

echo "🚀 Installing SEO Content Generator Output Style..."
echo ""

# Define paths
SOURCE_FILE=".claude/output-styles/seo-content-generator.md"
USER_OUTPUT_STYLES_DIR="$HOME/.config/claude/output-styles"
DEST_FILE="$USER_OUTPUT_STYLES_DIR/seo-content-generator.md"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "❌ Error: Source file not found at $SOURCE_FILE"
    echo "Please run this script from the Seed-SEO-Draft-Generator directory"
    exit 1
fi

# Create user output-styles directory if it doesn't exist
if [ ! -d "$USER_OUTPUT_STYLES_DIR" ]; then
    echo "📁 Creating output styles directory..."
    mkdir -p "$USER_OUTPUT_STYLES_DIR"
fi

# Check if output style already exists
if [ -f "$DEST_FILE" ]; then
    echo "⚠️  Output style already exists at $DEST_FILE"
    read -p "Do you want to overwrite it? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Installation cancelled"
        exit 0
    fi
fi

# Copy the output style
echo "📋 Copying output style to user directory..."
cp "$SOURCE_FILE" "$DEST_FILE"

# Verify installation
if [ -f "$DEST_FILE" ]; then
    echo "✅ Successfully installed SEO Content Generator output style!"
    echo ""
    echo "📝 How to use:"
    echo "1. Open any project in Claude Code"
    echo "2. Run command: /output-style"
    echo "3. Select 'seo-content-generator' from the list"
    echo "4. Start generating articles with just a keyword!"
    echo ""
    echo "💡 Tip: The output style is now available in ALL your Claude Code projects"
else
    echo "❌ Error: Failed to copy output style"
    exit 1
fi