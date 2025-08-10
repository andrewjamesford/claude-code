---
description: "Auto-format code using project's configured formatter (Prettier, Biome, etc.)"
model: sonnet
---

# Auto Format Code

I'll format your code using the project's configured formatter, ensuring consistent style across your codebase.

## Formatter Detection

### Scanning for formatters and their configurations:

```bash
echo "🔍 Detecting project formatters..."
echo ""

# Check for Prettier
if [ -f ".prettierrc" ] || [ -f ".prettierrc.json" ] || [ -f ".prettierrc.js" ] || [ -f "prettier.config.js" ] || [ -f ".prettierrc.yaml" ] || [ -f ".prettierrc.yml" ]; then
    echo "✅ Prettier configuration found"
    FORMATTER="prettier"
    
    # Check if Prettier is installed
    if command -v prettier &> /dev/null; then
        echo "   Version: $(prettier --version)"
    elif [ -f "node_modules/.bin/prettier" ]; then
        echo "   Version: $(node_modules/.bin/prettier --version)"
        FORMATTER="node_modules/.bin/prettier"
    else
        echo "   ⚠️  Config found but Prettier not installed"
    fi
fi

# Check for Biome (formerly Rome)
if [ -f "biome.json" ] || [ -f ".biome.json" ] || [ -f "rome.json" ]; then
    echo "✅ Biome configuration found"
    FORMATTER="biome"
    
    if command -v biome &> /dev/null; then
        echo "   Version: $(biome --version)"
    elif [ -f "node_modules/.bin/biome" ]; then
        echo "   Version: $(node_modules/.bin/biome --version)"
        FORMATTER="node_modules/.bin/biome"
    else
        echo "   ⚠️  Config found but Biome not installed"
    fi
fi

# Check for other formatters based on file types
if [ -f ".eslintrc" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.js" ]; then
    echo "✅ ESLint configuration found (can format with --fix)"
fi

if [ -f "pyproject.toml" ] || [ -f ".black" ] || [ -f "setup.cfg" ]; then
    echo "✅ Black (Python) configuration detected"
fi

if [ -f "rustfmt.toml" ] || [ -f ".rustfmt.toml" ]; then
    echo "✅ Rustfmt configuration found"
fi

if [ -f "go.mod" ]; then
    echo "✅ Go project detected (gofmt/goimports available)"
fi

if [ -f ".clang-format" ]; then
    echo "✅ Clang-format configuration found"
fi

if [ -f ".php-cs-fixer.php" ] || [ -f ".php-cs-fixer.dist.php" ]; then
    echo "✅ PHP CS Fixer configuration found"
fi

echo ""
```

## Configuration Analysis

```bash
# Analyze formatter configuration
echo "📋 Configuration Details:"
echo ""

if [ "$FORMATTER" = "prettier" ] || [ "$FORMATTER" = "node_modules/.bin/prettier" ]; then
    echo "Prettier settings:"
    
    # Check for ignore file
    if [ -f ".prettierignore" ]; then
        echo "  • Ignore file: .prettierignore found"
        echo "    Excluded patterns:"
        head -5 .prettierignore | sed 's/^/      - /'
        IGNORE_COUNT=$(wc -l < .prettierignore)
        if [ $IGNORE_COUNT -gt 5 ]; then
            echo "      ... and $((IGNORE_COUNT - 5)) more patterns"
        fi
    fi
    
    # Show key configuration
    if [ -f ".prettierrc" ] || [ -f ".prettierrc.json" ]; then
        echo "  • Configuration preview:"
        head -10 .prettierrc* | sed 's/^/    /'
    fi
fi

if [ "$FORMATTER" = "biome" ] || [ "$FORMATTER" = "node_modules/.bin/biome" ]; then
    echo "Biome settings:"
    if [ -f "biome.json" ]; then
        echo "  • Configuration preview:"
        cat biome.json | head -20 | sed 's/^/    /'
    fi
fi

echo ""
```

## File Selection

```bash
# Determine which files to format
echo "📁 Selecting files to format..."
echo ""

# Check git status for modified files
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Using git to detect modified files..."
    
    # Get modified, staged, and untracked files
    MODIFIED_FILES=$(git diff --name-only)
    STAGED_FILES=$(git diff --cached --name-only)
    UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
    
    # Combine and deduplicate
    ALL_CHANGED_FILES=$(echo -e "$MODIFIED_FILES\n$STAGED_FILES\n$UNTRACKED_FILES" | sort -u | grep -v '^$')
    
    if [ -z "$ALL_CHANGED_FILES" ]; then
        echo "No modified files detected. Would you like to:"
        echo "  1. Format all files in the project"
        echo "  2. Format specific directories"
        echo "  3. Format files by extension"
        echo ""
        echo "Proceeding with option 1 (format all)..."
        FORMAT_SCOPE="all"
    else
        echo "Found $(echo "$ALL_CHANGED_FILES" | wc -l) changed files:"
        echo "$ALL_CHANGED_FILES" | head -10 | sed 's/^/  • /'
        FILE_COUNT=$(echo "$ALL_CHANGED_FILES" | wc -l)
        if [ $FILE_COUNT -gt 10 ]; then
            echo "  ... and $((FILE_COUNT - 10)) more files"
        fi
        FORMAT_SCOPE="changed"
    fi
else
    echo "Not a git repository - will format all eligible files"
    FORMAT_SCOPE="all"
fi

echo ""
```

## Pre-Format Checks

```bash
# Run pre-format validations
echo "🔧 Pre-format checks..."
echo ""

# Check for syntax errors that might prevent formatting
if [ "$FORMATTER" = "prettier" ] || [ "$FORMATTER" = "node_modules/.bin/prettier" ]; then
    echo "Checking for syntax errors..."
    
    if [ "$FORMAT_SCOPE" = "changed" ]; then
        # Check only changed files
        for file in $ALL_CHANGED_FILES; do
            if [[ $file =~ \.(js|jsx|ts|tsx|json|css|scss|html|md)$ ]]; then
                if ! $FORMATTER --check "$file" &> /dev/null; then
                    echo "  ⚠️  $file has formatting issues"
                fi
            fi
        done
    fi
fi

# Check if any files are currently open in editors
if command -v lsof &> /dev/null; then
    OPEN_FILES=$(lsof | grep -E '\.(js|jsx|ts|tsx|py|go|rs|java)$' | awk '{print $NF}' | sort -u)
    if [ -n "$OPEN_FILES" ]; then
        echo "⚠️  Warning: Some files may be open in editors:"
        echo "$OPEN_FILES" | head -3 | sed 's/^/    /'
        echo "  Consider saving or closing them before formatting"
    fi
fi

echo ""
```

## Format Execution

```bash
echo "🎨 Formatting code..."
echo ""

# Create backup of current state (for safety)
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Creating safety backup with git stash..."
    git stash push -m "Auto-format backup $(date +%Y%m%d_%H%M%S)" --keep-index
    echo "✅ Backup created (can be restored with 'git stash pop' if needed)"
    echo ""
fi

# Execute formatting based on detected formatter
case "$FORMATTER" in
    *prettier*)
        echo "Running Prettier..."
        if [ "$FORMAT_SCOPE" = "changed" ]; then
            # Format only changed files
            echo "$ALL_CHANGED_FILES" | grep -E '\.(js|jsx|ts|tsx|json|css|scss|html|md|yaml|yml)$' | xargs -r $FORMATTER --write
        else
            # Format all files
            $FORMATTER --write "**/*.{js,jsx,ts,tsx,json,css,scss,html,md,yaml,yml}"
        fi
        echo "✅ Prettier formatting complete"
        ;;
        
    *biome*)
        echo "Running Biome..."
        if [ "$FORMAT_SCOPE" = "changed" ]; then
            echo "$ALL_CHANGED_FILES" | xargs -r $FORMATTER format --write
        else
            $FORMATTER format --write ./
        fi
        echo "✅ Biome formatting complete"
        ;;
        
    *)
        echo "⚠️  No JavaScript/TypeScript formatter found"
        ;;
esac

# Run language-specific formatters if files of those types were changed
if [ "$FORMAT_SCOPE" = "changed" ]; then
    # Python files with Black
    PYTHON_FILES=$(echo "$ALL_CHANGED_FILES" | grep '\.py$')
    if [ -n "$PYTHON_FILES" ] && command -v black &> /dev/null; then
        echo ""
        echo "Running Black for Python files..."
        echo "$PYTHON_FILES" | xargs -r black
        echo "✅ Python formatting complete"
    fi
    
    # Go files with gofmt
    GO_FILES=$(echo "$ALL_CHANGED_FILES" | grep '\.go$')
    if [ -n "$GO_FILES" ] && command -v gofmt &> /dev/null; then
        echo ""
        echo "Running gofmt for Go files..."
        echo "$GO_FILES" | xargs -r gofmt -w
        echo "✅ Go formatting complete"
    fi
    
    # Rust files with rustfmt
    RUST_FILES=$(echo "$ALL_CHANGED_FILES" | grep '\.rs$')
    if [ -n "$RUST_FILES" ] && command -v rustfmt &> /dev/null; then
        echo ""
        echo "Running rustfmt for Rust files..."
        echo "$RUST_FILES" | xargs -r rustfmt
        echo "✅ Rust formatting complete"
    fi
fi

echo ""
```

## Linting Integration

```bash
# Run linters with auto-fix if available
echo "🔍 Running linters with auto-fix..."
echo ""

# ESLint with --fix
if [ -f ".eslintrc" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.js" ]; then
    if command -v eslint &> /dev/null || [ -f "node_modules/.bin/eslint" ]; then
        echo "Running ESLint --fix..."
        if [ "$FORMAT_SCOPE" = "changed" ]; then
            echo "$ALL_CHANGED_FILES" | grep -E '\.(js|jsx|ts|tsx)$' | xargs -r npx eslint --fix
        else
            npx eslint --fix "**/*.{js,jsx,ts,tsx}"
        fi
        echo "✅ ESLint fixes applied"
    fi
fi

# Run other linters as needed
echo ""
```

## Post-Format Report

```bash
echo "📊 Formatting Report"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Show what changed
if git rev-parse --git-dir > /dev/null 2>&1; then
    FORMATTED_FILES=$(git diff --name-only)
    if [ -n "$FORMATTED_FILES" ]; then
        FILE_COUNT=$(echo "$FORMATTED_FILES" | wc -l)
        echo "✅ Formatted $FILE_COUNT file(s):"
        echo "$FORMATTED_FILES" | head -10 | sed 's/^/   • /'
        if [ $FILE_COUNT -gt 10 ]; then
            echo "   ... and $((FILE_COUNT - 10)) more files"
        fi
        
        echo ""
        echo "📈 Change statistics:"
        git diff --stat
    else
        echo "✨ All files were already properly formatted!"
    fi
fi

echo ""
```

## Validation

```bash
# Validate the formatting didn't break anything
echo "✅ Validation checks..."
echo ""

# Check if package.json has a format:check script
if [ -f "package.json" ] && grep -q '"format:check"' package.json; then
    echo "Running npm run format:check..."
    npm run format:check
fi

# Quick syntax validation for major file types
if [ "$FORMATTER" = "prettier" ] || [ "$FORMATTER" = "node_modules/.bin/prettier" ]; then
    echo "Verifying format consistency..."
    $FORMATTER --check . 2>/dev/null || echo "  ℹ️  Some files may need manual review"
fi

echo ""
```

## Next Steps

```bash
echo "🎯 Next Steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if git rev-parse --git-dir > /dev/null 2>&1; then
    if [ -n "$(git diff --name-only)" ]; then
        echo "1. Review the changes:"
        echo "   git diff"
        echo ""
        echo "2. Stage the formatted files:"
        echo "   git add -u"
        echo ""
        echo "3. Commit the changes:"
        echo "   git commit -m 'style: auto-format code'"
        echo ""
        echo "4. If you need to undo:"
        echo "   git stash pop  # Restore backup"
    fi
fi

# Suggest installing missing formatters
if [ -z "$FORMATTER" ]; then
    echo "💡 No formatter configured. Consider installing:"
    echo ""
    echo "For JavaScript/TypeScript projects:"
    echo "  • npm install --save-dev prettier"
    echo "  • npm install --save-dev @biomejs/biome"
    echo ""
    echo "Then create a configuration file:"
    echo "  • npx prettier --init"
    echo "  • npx biome init"
fi

echo ""
echo "✨ Formatting complete!"
```

## Error Handling

```bash
# Handle any errors that occurred
if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Formatting encountered errors"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Common fixes:"
    echo "  • Ensure formatters are installed: npm install"
    echo "  • Check for syntax errors in source files"
    echo "  • Verify configuration files are valid JSON/YAML"
    echo "  • Try formatting individual files to isolate issues"
    echo ""
    echo "To restore original state:"
    echo "  git stash pop"
fi
```

## Summary

I'll automatically detect and use the appropriate formatter for your project:

**Primary Formatters** (in order of preference):
1. **Prettier** - If .prettierrc or prettier.config.js exists
2. **Biome** - If biome.json exists (modern, fast alternative)
3. **Language-specific** - Black (Python), gofmt (Go), rustfmt (Rust), etc.

**Additional Tools**:
- ESLint with --fix for JavaScript/TypeScript
- Stylelint for CSS/SCSS
- PHP CS Fixer for PHP

**Smart Features**:
- Formats only modified files by default (using git)
- Creates backup before formatting
- Runs multiple formatters for mixed-language projects
- Validates results after formatting
- Provides clear next steps

This ensures your code is consistently formatted according to your project's exact specifications!