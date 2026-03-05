#!/bin/bash
#
# Alex Agent Plugin Installer for macOS/Linux
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/fabioc-aloha/AlexAgent/main/install.sh | bash
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/fabioc-aloha/AlexAgent.git"
INSTALL_PATH="$HOME/.alex-agent"
PLUGIN_PATH="$INSTALL_PATH/plugin"

echo ""
echo -e "${CYAN}🧠 Alex Agent Plugin Installer${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

# Check Git
if command -v git &> /dev/null; then
    echo -e "  ${GREEN}✓ Git found${NC}"
else
    echo -e "  ${RED}✗ Git not found. Please install Git first.${NC}"
    exit 1
fi

# Check VS Code
if command -v code &> /dev/null; then
    echo -e "  ${GREEN}✓ VS Code found${NC}"
else
    echo -e "  ${YELLOW}⚠ VS Code not found in PATH (install may still work)${NC}"
fi

# Check Node.js (optional)
if command -v node &> /dev/null; then
    echo -e "  ${GREEN}✓ Node.js found (MCP tools will work)${NC}"
else
    echo -e "  ${YELLOW}⚠ Node.js not found (MCP tools won't work, but plugin will)${NC}"
fi

echo ""

# Clone or update repository
if [ -d "$INSTALL_PATH" ]; then
    echo -e "${YELLOW}Updating existing installation...${NC}"
    cd "$INSTALL_PATH"
    if git pull --quiet; then
        echo -e "  ${GREEN}✓ Updated to latest version${NC}"
    else
        echo -e "  ${YELLOW}⚠ Update failed, continuing with existing version${NC}"
    fi
else
    echo -e "${YELLOW}Cloning Alex Agent Plugin...${NC}"
    git clone --quiet "$REPO_URL" "$INSTALL_PATH"
    echo -e "  ${GREEN}✓ Cloned to $INSTALL_PATH${NC}"
fi

echo ""

# Determine VS Code settings path
if [ "$(uname)" == "Darwin" ]; then
    # macOS
    SETTINGS_PATH="$HOME/Library/Application Support/Code/User/settings.json"
else
    # Linux
    SETTINGS_PATH="$HOME/.config/Code/User/settings.json"
fi

# Configure VS Code settings
echo -e "${YELLOW}Configuring VS Code...${NC}"

# Create settings directory if needed
SETTINGS_DIR=$(dirname "$SETTINGS_PATH")
mkdir -p "$SETTINGS_DIR"

# Create or update settings.json
if [ -f "$SETTINGS_PATH" ]; then
    # Check if jq is available for JSON manipulation
    if command -v jq &> /dev/null; then
        # Use jq to update settings
        TEMP_FILE=$(mktemp)
        jq --arg path "$PLUGIN_PATH" '
            .["chat.agent.enabled"] = true |
            .["chat.plugins.enabled"] = true |
            .["chat.plugins.paths"][$path] = true
        ' "$SETTINGS_PATH" > "$TEMP_FILE" && mv "$TEMP_FILE" "$SETTINGS_PATH"
        echo -e "  ${GREEN}✓ VS Code settings updated${NC}"
    else
        echo -e "  ${YELLOW}⚠ jq not installed. Please add manually to settings.json:${NC}"
        echo ""
        echo '    "chat.agent.enabled": true,'
        echo '    "chat.plugins.enabled": true,'
        echo "    \"chat.plugins.paths\": { \"$PLUGIN_PATH\": true }"
        echo ""
    fi
else
    # Create new settings file
    cat > "$SETTINGS_PATH" << EOF
{
    "chat.agent.enabled": true,
    "chat.plugins.enabled": true,
    "chat.plugins.paths": {
        "$PLUGIN_PATH": true
    }
}
EOF
    echo -e "  ${GREEN}✓ VS Code settings created${NC}"
fi

echo ""
echo -e "${CYAN}================================${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${CYAN}================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Restart VS Code (or Cmd+Shift+P → 'Reload Window')"
echo "  2. Open Copilot Chat (Cmd+Ctrl+I or Ctrl+Alt+I)"
echo "  3. Say 'Who are you?' to meet Alex"
echo ""
echo -e "Plugin installed at: ${PLUGIN_PATH}"
echo ""
