---
description: "Follow project conventions to git commit"
allowed-tools: Bash(git)
---

# Git Commit

I'll analyze your changes and create a meaningful commit message following your project's conventions.

## Initial Repository Check

```bash
# Verify git repository and show current status
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not a git repository"
    echo "Please navigate to a git repository or run 'git init'"
    exit 1
fi

echo "📁 Repository: $(basename $(git rev-parse --show-toplevel))"
echo "🌿 Current branch: $(git branch --show-current)"
echo ""

# Check for changes
if git diff --cached --quiet && git diff --quiet; then
    echo "✨ Working directory is clean - no changes to commit"
    
    # Check for uncommitted changes in other branches
    if [ $(git status --porcelain | wc -l) -eq 0 ]; then
        echo ""
        echo "💡 Recent commits on this branch:"
        git log --oneline -5
    fi
    exit 0
fi
```

## Convention Detection

```bash
# Analyze recent commits to detect conventions
echo "🔍 Analyzing project commit conventions..."
echo ""

# Check for conventional commits pattern
if git log --oneline -20 | grep -qE '^[a-f0-9]+ (feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?:'; then
    echo "✅ Detected: Conventional Commits format"
    CONVENTION="conventional"
elif git log --oneline -20 | grep -qE '^[a-f0-9]+ \[.+\]'; then
    echo "✅ Detected: Bracket prefix format [TYPE]"
    CONVENTION="bracket"
elif git log --oneline -20 | grep -qE '^[a-f0-9]+ [A-Z]+-[0-9]+'; then
    echo "✅ Detected: Issue/ticket reference format"
    CONVENTION="ticket"
else
    echo "ℹ️  No specific convention detected, will use best practices"
    CONVENTION="standard"
fi

# Show example recent commits
echo ""
echo "📝 Recent commit examples:"
git log --oneline -5
echo ""
```

## Change Analysis

```bash
# Detailed change analysis
echo "📊 Analyzing changes..."
echo ""

# Check what's staged vs unstaged
STAGED_COUNT=$(git diff --cached --name-only | wc -l)
UNSTAGED_COUNT=$(git diff --name-only | wc -l)
UNTRACKED_COUNT=$(git ls-files --others --exclude-standard | wc -l)

echo "Changes summary:"
echo "  📦 Staged files: $STAGED_COUNT"
echo "  📝 Modified (unstaged): $UNSTAGED_COUNT"
echo "  ❓ Untracked files: $UNTRACKED_COUNT"
echo ""

# Show detailed status
git status --short
echo ""

# If nothing staged, offer to stage
if [ $STAGED_COUNT -eq 0 ]; then
    echo "⚠️  No files are staged for commit"
    echo ""
    echo "Would you like me to:"
    echo "  1. Stage all modified files (git add -u)"
    echo "  2. Stage all changes including new files (git add -A)"
    echo "  3. Let you stage files manually"
    echo ""
    echo "Proceeding with option 1 (staging modified files only)..."
    git add -u
    echo "✅ Staged modified files"
    echo ""
fi

# Show what will be committed
echo "📋 Files to be committed:"
git diff --cached --name-status
echo ""

# Analyze change patterns
echo "🔬 Change analysis:"
git diff --cached --stat
echo ""

# Detect file types and probable change type
CHANGED_FILES=$(git diff --cached --name-only)
CHANGE_TYPE="update"
SCOPE=""

# Smart detection of change type
if echo "$CHANGED_FILES" | grep -qE '\.(test|spec)\.(js|ts|py|rb|go)$'; then
    CHANGE_TYPE="test"
    SCOPE="tests"
elif echo "$CHANGED_FILES" | grep -qE '(README|CHANGELOG|\.md$)'; then
    CHANGE_TYPE="docs"
    SCOPE="documentation"
elif echo "$CHANGED_FILES" | grep -qE '(package\.json|requirements\.txt|Gemfile|go\.mod)'; then
    CHANGE_TYPE="chore"
    SCOPE="deps"
elif echo "$CHANGED_FILES" | grep -qE '\.(css|scss|less)$'; then
    CHANGE_TYPE="style"
    SCOPE="ui"
elif git diff --cached | grep -q "fix\|bug\|issue\|error"; then
    CHANGE_TYPE="fix"
elif git diff --cached | grep -q "add\|new\|feature\|implement"; then
    CHANGE_TYPE="feat"
elif git diff --cached | grep -q "refactor\|clean\|improve"; then
    CHANGE_TYPE="refactor"
fi

# Extract likely component/scope from file paths
if [ -z "$SCOPE" ]; then
    SCOPE=$(echo "$CHANGED_FILES" | head -1 | sed -E 's|^[^/]+/||; s|/.*||' | tr '[:upper:]' '[:lower:]')
fi

echo "Detected change type: $CHANGE_TYPE"
echo "Detected scope: ${SCOPE:-none}"
echo ""
```

## Commit Message Generation

```bash
# Check for work-in-progress indicators
if git diff --cached | grep -qE '(TODO|FIXME|XXX|HACK|WIP)'; then
    echo "⚠️  Warning: Found work-in-progress markers in changes"
    echo "Consider completing TODOs before committing"
    echo ""
fi

# Generate commit message based on convention
echo "✍️  Generating commit message..."
echo ""

# Get a summary of the actual changes
CHANGES_SUMMARY=$(git diff --cached --unified=0 | grep -E '^\+[^+]' | head -20)

# Build the commit message
case $CONVENTION in
    "conventional")
        if [ -n "$SCOPE" ]; then
            COMMIT_MSG="$CHANGE_TYPE($SCOPE): "
        else
            COMMIT_MSG="$CHANGE_TYPE: "
        fi
        ;;
    "bracket")
        COMMIT_MSG="[$CHANGE_TYPE] "
        ;;
    "ticket")
        # Try to extract ticket number from branch name
        TICKET=$(git branch --show-current | grep -oE '[A-Z]+-[0-9]+' || echo "")
        if [ -n "$TICKET" ]; then
            COMMIT_MSG="$TICKET: "
        else
            COMMIT_MSG=""
        fi
        ;;
    *)
        COMMIT_MSG=""
        ;;
esac

# Add descriptive subject line
# This is where I'll analyze the changes and create a meaningful description
echo "Proposed commit message:"
echo "------------------------"
```

I'll now analyze the specific changes to create a descriptive commit message that:

- Summarizes what changed (not how)
- Uses present tense ("add" not "added")
- Stays under 50 characters for the subject
- Includes a body if the change is complex

```bash
# Create the commit with generated message
# The actual message will be based on the analysis above

# Example of the final commit command:
# git commit -m "feat(auth): add two-factor authentication support" \
#           -m "" \
#           -m "- Implement TOTP generation and validation" \
#           -m "- Add QR code generation for authenticator apps" \
#           -m "- Update user model with 2FA fields"

echo ""
echo "🚀 Ready to commit!"
echo ""
```

## Pre-commit Validation

```bash
# Run any pre-commit hooks or checks
if [ -f .git/hooks/pre-commit ]; then
    echo "🔧 Running pre-commit hooks..."
    if .git/hooks/pre-commit; then
        echo "✅ Pre-commit checks passed"
    else
        echo "❌ Pre-commit checks failed"
        echo "Please fix the issues and try again"
        exit 1
    fi
fi

# Check for common issues
echo "🔍 Final checks:"

# Large file check
LARGE_FILES=$(git diff --cached --name-only | xargs -I {} sh -c 'test -f "{}" && du -k "{}" | awk "\$1 > 1000 {print \$2}"')
if [ -n "$LARGE_FILES" ]; then
    echo "⚠️  Warning: Large files detected (>1MB):"
    echo "$LARGE_FILES"
fi

# Sensitive information check
if git diff --cached | grep -qE '(password|secret|token|api[_-]key|private[_-]key)'; then
    echo "⚠️  Warning: Possible sensitive information detected"
    echo "Please review changes for exposed credentials"
fi

echo ""
```

## Commit Execution

After reviewing the proposed message, I'll execute the commit using your existing git configuration.

```bash
# The actual commit will be executed here
# git commit -m "generated message based on analysis"
```

## Post-commit Options

```bash
# After successful commit
echo "✅ Commit created successfully!"
echo ""
echo "Next steps:"
echo "  • Push to remote: git push origin $(git branch --show-current)"
echo "  • Create a pull request"
echo "  • Continue with next task"
```

## Important Notes

**I will NEVER:**

- Add "(Co-)authored-by" or any Claude signatures
- Modify your git configuration
- Include AI/assistant attribution
- Force push or alter commit history
- Commit without showing you the message first

**I will ALWAYS:**

- Use your existing git user configuration
- Follow detected project conventions
- Validate changes before committing
- Explain what will be committed
- Maintain full ownership of your commits

Ready to analyze your changes and create a meaningful commit!
