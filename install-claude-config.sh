#!/bin/bash

# Script to install Claude Code configuration files to user's .claude directory

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directory
CLAUDE_DIR="$HOME/.claude"
BACKUPS_DIR="$CLAUDE_DIR/backups"

echo -e "${BLUE}Claude Code Configuration Installer${NC}"
echo "======================================"

# Check if source files exist
if [[ ! -f "$SCRIPT_DIR/CLAUDE.md" ]]; then
    echo -e "${RED}Error: CLAUDE.md not found in $SCRIPT_DIR${NC}"
    exit 1
fi

if [[ ! -d "$SCRIPT_DIR/agents" ]]; then
    echo -e "${RED}Error: agents directory not found in $SCRIPT_DIR${NC}"
    exit 1
fi

if [[ ! -d "$SCRIPT_DIR/commands" ]]; then
    echo -e "${RED}Error: commands directory not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Create .claude and backups directories if they don't exist
echo -e "${BLUE}Creating .claude directory...${NC}"
mkdir -p "$CLAUDE_DIR"
mkdir -p "$BACKUPS_DIR"

# Function to backup existing files
backup_if_exists() {
    local target="$1"
    local name="$2"
    if [[ -e "$target" ]]; then
        local timestamp="$(date +%Y%m%d_%H%M%S)"
        local backup="$BACKUPS_DIR/${name}.backup.$timestamp"
        echo -e "${YELLOW}Backing up existing $target to $backup${NC}"
        mv "$target" "$backup"
    fi
}

# Copy CLAUDE.md
echo -e "${BLUE}Installing CLAUDE.md...${NC}"
backup_if_exists "$CLAUDE_DIR/CLAUDE.md" "CLAUDE.md"
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/"

# Copy agents directory
echo -e "${BLUE}Installing agents directory...${NC}"
backup_if_exists "$CLAUDE_DIR/agents" "agents"
cp -r "$SCRIPT_DIR/agents" "$CLAUDE_DIR/"

# Copy commands directory
echo -e "${BLUE}Installing commands directory...${NC}"
backup_if_exists "$CLAUDE_DIR/commands" "commands"
cp -r "$SCRIPT_DIR/commands" "$CLAUDE_DIR/"

# Set appropriate permissions
echo -e "${BLUE}Setting permissions...${NC}"
chmod -R 755 "$CLAUDE_DIR"

echo
echo -e "${GREEN}✓ Installation completed successfully!${NC}"
echo
echo "Files installed to: $CLAUDE_DIR"
echo "├── CLAUDE.md"
echo "├── agents/"
find "$CLAUDE_DIR/agents" -name "*.md" | sed 's|.*/|│   ├── |' | head -10
echo "└── commands/"
find "$CLAUDE_DIR/commands" -name "*.md" | sed 's|.*/|    ├── |' | head -10

echo
echo -e "${BLUE}Note:${NC} Any existing files were backed up to: $BACKUPS_DIR"
echo -e "${BLUE}Usage:${NC} These configurations will now be available to Claude Code globally"