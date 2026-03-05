#!/bin/bash
#
# Configure VS Code settings for the Alex Agent Plugin.
# Run this from the cloned AlexAgent folder.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_PATH="$SCRIPT_DIR/plugin"

if [ ! -d "$PLUGIN_PATH" ]; then
    echo "✗ plugin/ folder not found. Run this from the AlexAgent repo root."
    exit 1
fi

echo ""
echo "🧠 Alex Agent Plugin Setup"
echo ""

# Determine VS Code settings path
if [ "$(uname)" = "Darwin" ]; then
    SETTINGS_PATH="$HOME/Library/Application Support/Code/User/settings.json"
else
    SETTINGS_PATH="$HOME/.config/Code/User/settings.json"
fi

SETTINGS_DIR=$(dirname "$SETTINGS_PATH")
mkdir -p "$SETTINGS_DIR"

if [ -f "$SETTINGS_PATH" ]; then
    if command -v jq &> /dev/null; then
        TEMP_FILE=$(mktemp)
        jq --arg path "$PLUGIN_PATH" '
            .["chat.agent.enabled"] = true |
            .["chat.plugins.enabled"] = true |
            .["chat.plugins.paths"][$path] = true
        ' "$SETTINGS_PATH" > "$TEMP_FILE" && mv "$TEMP_FILE" "$SETTINGS_PATH"
        echo "✓ VS Code settings updated"
    else
        echo "⚠ jq not installed. Add manually to settings.json:"
        echo ""
        echo "  \"chat.agent.enabled\": true,"
        echo "  \"chat.plugins.enabled\": true,"
        echo "  \"chat.plugins.paths\": { \"$PLUGIN_PATH\": true }"
        echo ""
        exit 0
    fi
else
    cat > "$SETTINGS_PATH" << EOF
{
    "chat.agent.enabled": true,
    "chat.plugins.enabled": true,
    "chat.plugins.paths": {
        "$PLUGIN_PATH": true
    }
}
EOF
    echo "✓ VS Code settings created"
fi

echo "  Plugin path: $PLUGIN_PATH"
echo ""
echo "Next: Ctrl+Shift+P → 'Reload Window', then open Copilot Chat."
echo ""
