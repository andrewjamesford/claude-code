---
description: "Create and manage git worktrees for parallel branch development"
allowed-tools: Bash(git)
---

# Git Worktree Management

I'll help you create and manage git worktrees, allowing you to work on multiple branches simultaneously without switching contexts.

## Initial Repository Check

```bash
# Verify git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not a git repository"
    echo "Please navigate to a git repository first"
    exit 1
fi

echo "📁 Repository: $(basename $(git rev-parse --show-toplevel))"
echo "🌿 Current branch: $(git branch --show-current)"
echo "📍 Repository root: $(git rev-parse --show-toplevel)"
echo ""

# Check if we're already in a worktree
if [ -f "$(git rev-parse --git-dir)/gitdir" ]; then
    echo "ℹ️  You're currently in a worktree: $(basename $(pwd))"
    echo ""
fi
```

## Worktree Status

```bash
# Show existing worktrees
echo "🌳 Existing worktrees:"
git worktree list
echo ""

# Count worktrees
WORKTREE_COUNT=$(git worktree list | wc -l)
echo "Total worktrees: $WORKTREE_COUNT"
echo ""
```

## Branch Analysis

```bash
# Get available branches
echo "📋 Available branches:"
echo ""
echo "Local branches:"
git branch --format='  %(refname:short)%(if)%(HEAD)%(then) (current)%(end)'
echo ""

echo "Remote branches:"
git branch -r --format='  %(refname:short)' | grep -v HEAD
echo ""

# Suggest branch name if creating from an issue or feature
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" == *"main"* ]] || [[ "$CURRENT_BRANCH" == *"master"* ]] || [[ "$CURRENT_BRANCH" == *"develop"* ]]; then
    echo "💡 Tip: You're on the $CURRENT_BRANCH branch"
    echo "   Consider creating a feature or bugfix branch"
    echo ""
fi
```

## Worktree Creation

```bash
# Determine worktree location and branch name
echo "🔨 Creating new worktree..."
echo ""

# Get repository root and name
REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")
PARENT_DIR=$(dirname "$REPO_ROOT")

# Prompt for branch name (in actual usage, this would be provided)
echo "Enter branch name (or press Enter to auto-generate):"
read -r BRANCH_NAME

# Auto-generate branch name if not provided
if [ -z "$BRANCH_NAME" ]; then
    # Generate based on current date and type
    TIMESTAMP=$(date +%Y%m%d)
    echo "Select branch type:"
    echo "  1. feature"
    echo "  2. bugfix"
    echo "  3. hotfix"
    echo "  4. experimental"
    read -r BRANCH_TYPE_NUM
    
    case $BRANCH_TYPE_NUM in
        1) BRANCH_PREFIX="feature" ;;
        2) BRANCH_PREFIX="bugfix" ;;
        3) BRANCH_PREFIX="hotfix" ;;
        4) BRANCH_PREFIX="experimental" ;;
        *) BRANCH_PREFIX="feature" ;;
    esac
    
    BRANCH_NAME="${BRANCH_PREFIX}/work-${TIMESTAMP}"
    echo "Generated branch name: $BRANCH_NAME"
fi

# Clean branch name (remove special characters)
CLEAN_BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/[^a-zA-Z0-9/_-]/-/g')

# Determine worktree path
WORKTREE_DIR="${PARENT_DIR}/${REPO_NAME}-${CLEAN_BRANCH_NAME##*/}"

echo ""
echo "Configuration:"
echo "  📁 Worktree location: $WORKTREE_DIR"
echo "  🌿 Branch name: $BRANCH_NAME"
echo ""
```

## Check for Conflicts

```bash
# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    echo "⚠️  Branch '$BRANCH_NAME' already exists"
    echo ""
    echo "Options:"
    echo "  1. Create worktree with existing branch"
    echo "  2. Choose a different name"
    echo "  3. Cancel"
    read -r CONFLICT_CHOICE
    
    case $CONFLICT_CHOICE in
        1)
            echo "Creating worktree with existing branch..."
            CREATE_NEW_BRANCH="false"
            ;;
        2)
            echo "Please run the command again with a different branch name"
            exit 0
            ;;
        *)
            echo "Operation cancelled"
            exit 0
            ;;
    esac
else
    CREATE_NEW_BRANCH="true"
fi

# Check if worktree directory already exists
if [ -d "$WORKTREE_DIR" ]; then
    echo "❌ Error: Directory already exists: $WORKTREE_DIR"
    echo "Please choose a different branch name or remove the existing directory"
    exit 1
fi
```

## Create Worktree

```bash
# Execute worktree creation
echo "🚀 Creating worktree..."
echo ""

if [ "$CREATE_NEW_BRANCH" = "true" ]; then
    # Create new branch and worktree
    echo "Creating new branch '$BRANCH_NAME' with worktree..."
    if git worktree add -b "$BRANCH_NAME" "$WORKTREE_DIR"; then
        echo "✅ Worktree created successfully!"
    else
        echo "❌ Failed to create worktree"
        exit 1
    fi
else
    # Create worktree with existing branch
    echo "Creating worktree for existing branch '$BRANCH_NAME'..."
    if git worktree add "$WORKTREE_DIR" "$BRANCH_NAME"; then
        echo "✅ Worktree created successfully!"
    else
        echo "❌ Failed to create worktree"
        exit 1
    fi
fi

echo ""
echo "📊 Updated worktree list:"
git worktree list
echo ""
```

## Post-Creation Setup

```bash
# Navigate to the new worktree and set it up
echo "🔧 Setting up worktree..."
cd "$WORKTREE_DIR" || exit 1

# Check for common setup files
if [ -f "package.json" ]; then
    echo "📦 Node.js project detected"
    echo "Installing dependencies..."
    if command -v npm &> /dev/null; then
        npm install
    elif command -v yarn &> /dev/null; then
        yarn install
    elif command -v pnpm &> /dev/null; then
        pnpm install
    fi
fi

if [ -f "requirements.txt" ]; then
    echo "🐍 Python project detected"
    echo "Consider creating a virtual environment and installing dependencies:"
    echo "  python -m venv venv"
    echo "  source venv/bin/activate"
    echo "  pip install -r requirements.txt"
fi

if [ -f "Gemfile" ]; then
    echo "💎 Ruby project detected"
    echo "Installing dependencies..."
    if command -v bundle &> /dev/null; then
        bundle install
    fi
fi

if [ -f "go.mod" ]; then
    echo "🐹 Go project detected"
    echo "Downloading dependencies..."
    go mod download
fi

echo ""
echo "✨ Worktree setup complete!"
echo ""
```

## Usage Instructions

```bash
echo "📝 Next steps:"
echo ""
echo "1. Navigate to your worktree:"
echo "   cd $WORKTREE_DIR"
echo ""
echo "2. Start working on your feature/fix"
echo ""
echo "3. When done, you can remove the worktree:"
echo "   git worktree remove $WORKTREE_DIR"
echo ""
echo "4. To switch between worktrees:"
echo "   - Main repository: cd $REPO_ROOT"
echo "   - This worktree: cd $WORKTREE_DIR"
echo ""
```

## Worktree Management Commands

```bash
# Additional useful commands
echo "🛠️  Useful worktree commands:"
echo ""
echo "List all worktrees:"
echo "  git worktree list"
echo ""
echo "Remove a worktree:"
echo "  git worktree remove <path>"
echo ""
echo "Prune worktree information:"
echo "  git worktree prune"
echo ""
echo "Lock a worktree (prevent deletion):"
echo "  git worktree lock <path>"
echo ""
echo "Unlock a worktree:"
echo "  git worktree unlock <path>"
echo ""
```

## Benefits of Git Worktrees

**Why use worktrees instead of switching branches:**

- 🚀 **No context switching** - Keep multiple branches checked out simultaneously
- 💾 **Preserve working state** - No need to stash changes when switching tasks
- 🔧 **Parallel development** - Work on features while builds/tests run in another worktree
- 📦 **Separate dependencies** - Each worktree can have its own node_modules, venv, etc.
- 🐛 **Easy bug fixes** - Quickly create a worktree for hotfixes without disrupting feature work
- 🔍 **Code comparison** - Compare implementations across branches side-by-side

## Important Notes

**Best Practices:**

- Keep worktrees in a parallel directory structure (../repo-branch)
- Clean up worktrees when done to avoid clutter
- Use descriptive branch names for easy identification
- Run `git worktree prune` periodically to clean up metadata

**Limitations:**

- Can't check out the same branch in multiple worktrees
- Worktrees share the same git config and hooks
- Submodules need to be initialized in each worktree

Ready to create efficient parallel development environments with git worktrees!
