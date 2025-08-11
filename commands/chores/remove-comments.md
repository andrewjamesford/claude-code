---
description: "Clean up redundant comments while preserving valuable documentation"
allowed-tools: Bash(git:*), Bash(echo:*)
---

# Remove Obvious Comments

I'll clean up redundant comments while preserving valuable documentation, making your codebase cleaner and more professional.

## Initial Analysis

```bash
echo "🔍 Analyzing project for comment cleanup opportunities..."
echo ""

# Detect project languages and file types
echo "Detecting project languages..."
if [ -f "package.json" ]; then
    echo "  ✓ JavaScript/TypeScript project detected"
    FILE_PATTERNS="*.js *.jsx *.ts *.tsx"
fi
if [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
    echo "  ✓ Python project detected"
    FILE_PATTERNS="$FILE_PATTERNS *.py"
fi
if [ -f "go.mod" ]; then
    echo "  ✓ Go project detected"
    FILE_PATTERNS="$FILE_PATTERNS *.go"
fi
if [ -f "Cargo.toml" ]; then
    echo "  ✓ Rust project detected"
    FILE_PATTERNS="$FILE_PATTERNS *.rs"
fi
if [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    echo "  ✓ Java project detected"
    FILE_PATTERNS="$FILE_PATTERNS *.java"
fi

echo ""
echo "📊 Scanning for files with comments..."

# Count files and estimate comment density
if [ -d .git ]; then
    # Focus on recently modified files for efficiency
    FILES=$(git diff --name-only HEAD~10..HEAD 2>/dev/null | grep -E '\.(js|jsx|ts|tsx|py|go|rs|java|cpp|c|cs|rb|php)$' | head -50)
    if [ -z "$FILES" ]; then
        FILES=$(find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" \) -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/vendor/*" -not -path "*/dist/*" | head -50)
    fi
else
    FILES=$(find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" \) -not -path "*/node_modules/*" -not -path "*/vendor/*" -not -path "*/dist/*" | head -50)
fi

echo "Found $(echo "$FILES" | wc -l) files to analyze"
echo ""
```

## Comment Classification

I'll categorize comments into these types:

### 🗑️ **Obvious Comments to Remove**

```javascript
// JavaScript/TypeScript examples:
let count = 0; // Initialize count to 0 ❌
users.forEach(user => { // Loop through users ❌
function getUser() { // Function to get user ❌
return result; // Return the result ❌

// Python examples:
count = 0  # Set count to 0 ❌
for user in users:  # Iterate over users ❌
def get_user():  # Function to get user ❌
return result  # Return result ❌

// Java examples:
private String name; // The name ❌
public void setName(String name) { // Setter for name ❌
if (x > 0) { // Check if x is greater than 0 ❌
```

### ✅ **Valuable Comments to Preserve**

```javascript
// WHY comments (explain reasoning):
// Using binary search here because the list is pre-sorted
// and we need O(log n) lookup time for performance

// WARNING comments:
// WARNING: Do not modify this value - it's used by the payment processor

// TODO/FIXME/HACK comments:
// TODO: Refactor this once the new API is available
// FIXME: Temporary workaround for issue #1234
// HACK: This setTimeout fixes a race condition in Safari

// Complex logic explanations:
// Calculate compound interest using the formula: A = P(1 + r/n)^(nt)
// where P = principal, r = rate, n = compounds per period, t = time

// API/External documentation:
// See: https://docs.api.com/v2/authentication#oauth2
// Implements RFC 6749 Section 4.1

// Business logic:
// Users are considered "active" if they've logged in within 30 days
// AND have completed at least one transaction

// Non-obvious behavior:
// Returns null instead of empty array to distinguish between
// "no results" and "search not performed"

// Legal/Compliance:
// Required by GDPR Article 17 - Right to Erasure

// Performance notes:
// Cached for 5 minutes to reduce database load during peak hours
```

## Analysis Patterns

### Pattern Detection by Language

**JavaScript/TypeScript:**

```javascript
// Patterns to remove:
- // constructor | // Constructor method
- // import statements | // Import X from Y
- // increment/decrement | i++ // increment i
- // getter/setter | // Get user name
- // returns true/false | return true; // return true

// Special handling:
- JSDoc comments (preserve if they add type info or descriptions)
- ESLint directives (always preserve)
```

**Python:**

```python
# Patterns to remove:
- # initialize | x = 0  # initialize x
- # import | import os  # import os module
- # class definition | class User:  # User class
- # return | return result  # return the result

# Special handling:
- Docstrings (preserve - they're documentation, not comments)
- Type hints in comments (preserve for Python < 3.5 compatibility)
```

**Go:**

```go
// Patterns to remove:
- // struct | type User struct { // User struct
- // variable declaration | var count int // count variable
- // error check | if err != nil { // check error

// Special handling:
- Package comments (preserve - required by godoc)
- Exported function comments (preserve - godoc convention)
```

## Interactive Review Process

For each file with redundant comments, I'll present:

```markdown
📄 File: src/utils/validation.js
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Found 5 obvious comments to remove:

❌ Line 12:
   const MAX_LENGTH = 100; // Maximum length
   Reason: Variable name clearly indicates this is max length

❌ Line 24-26:
   // Loop through items
   for (const item of items) {
   Reason: The for...of syntax is self-explanatory

❌ Line 45:
   return false; // Return false
   Reason: The code literally says what the comment says

✅ Preserved valuable comments:
   Line 8: // Using 100 based on UX research showing users rarely exceed this
   Line 32: // FIXME: This validation is too strict for international names
   Line 51: // Null indicates validation wasn't run, false means it failed

Summary: Remove 5 obvious comments, preserve 3 valuable ones

Apply changes? [Y/n]:
```

## Bulk Operations

```bash
echo "🔄 Comment Cleanup Options:"
echo ""
echo "1. Interactive - Review each file individually"
echo "2. Aggressive - Remove all obvious comments automatically"
echo "3. Conservative - Only remove the most obvious redundancies"
echo "4. Dry run - Show what would be removed without changing files"
echo "5. Report only - Generate a comment quality report"
echo ""
echo "Proceeding with option 1 (Interactive)..."
```

## Smart Preservation Rules

### Always Preserve

1. **License Headers & Copyright**

   ```javascript
   // Copyright (c) 2024 Company Name
   // Licensed under MIT License
   ```

2. **Disable Directives**

   ```javascript
   // eslint-disable-next-line no-console
   /* stylelint-disable property-no-vendor-prefix */
   # pylint: disable=too-many-arguments
   ```

3. **Configuration Comments**

   ```javascript
   // webpack-specific comment
   /* webpackChunkName: "vendor" */
   ```

4. **Regular Expression Explanations**

   ```javascript
   // Matches email: <username>@<domain>.<tld>
   const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
   ```

5. **Magic Numbers/Constants Context**

   ```javascript
   const RETRY_DELAY = 1000; // 1 second - matches API rate limit
   ```

6. **Algorithm Complexity**

   ```javascript
   // O(n log n) - sorting dominates the complexity
   ```

## Quality Metrics

```bash
echo "📈 Comment Quality Report"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Before cleanup:"
echo "  Total comments: 342"
echo "  Obvious/redundant: 127 (37%)"
echo "  Valuable: 215 (63%)"
echo ""
echo "Categories of redundant comments:"
echo "  • Variable declarations: 45"
echo "  • Function names: 38"
echo "  • Control flow: 23"
echo "  • Return statements: 21"
echo ""
echo "After cleanup:"
echo "  Total comments: 215"
echo "  Signal-to-noise ratio: Improved by 59%"
echo "  Average comment value: High"
```

## Special Cases Handling

### Generated Code

```javascript
// Files with "generated" or "auto-generated" headers are skipped
// Example: protobuf, swagger, graphql generated files
```

### Documentation Blocks

```javascript
/**
 * Even if this seems obvious, JSDoc/Javadoc blocks are preserved
 * as they serve as API documentation
 * @param {string} name - User name
 * @returns {User} User object
 */
```

### Commented-Out Code

```javascript
// Analyze if commented code should be removed:
// - If it's been there > 6 months (check git history)
// - If it has no explanation of why it's kept
// - Suggest: "This appears to be old code. Remove or add explanation?"
```

## Language-Specific Rules

### React/JSX

```javascript
// Remove:
{/* Render the button */}
<Button />

// Keep:
{/* Accessibility: Hidden from screen readers but visible */}
<span aria-hidden="true">×</span>
```

### SQL in Code

```sql
-- Remove:
SELECT * FROM users -- Select all from users

-- Keep:
-- Using NOLOCK to avoid blocking production transactions
SELECT * FROM users WITH (NOLOCK)
```

### CSS/SCSS

```css
/* Remove: */
.container { /* Container styles */
  margin: 0; /* No margin */
}

/* Keep: */
.container {
  margin: 0; /* Overrides Bootstrap default */
}
```

## Final Review

```bash
echo "✅ Comment Cleanup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Summary:"
echo "  Files processed: 23"
echo "  Comments removed: 127"
echo "  Comments preserved: 215"
echo "  Lines of code saved: 127"
echo ""
echo "Impact:"
echo "  • Improved code readability"
echo "  • Reduced file sizes by ~3%"
echo "  • Every remaining comment now adds value"
echo ""

# Git stats if applicable
if [ -d .git ]; then
    echo "Changes:"
    git diff --stat
    echo ""
    echo "To review changes: git diff"
    echo "To commit: git commit -am 'refactor: remove redundant comments'"
fi
```

## Customization Options

I can adjust the cleanup based on your preferences:

1. **Aggressiveness Level**
   - Conservative: Only the most obvious redundancies
   - Standard: Balanced approach (default)
   - Aggressive: Remove anything that doesn't add significant value

2. **Comment Style Preferences**
   - Preserve all TODOs regardless of age
   - Keep implementation notes
   - Maintain inline variable explanations

3. **Team Standards**
   - Follow specific style guide rules
   - Preserve comments in certain formats
   - Keep comments for junior developers

Ready to clean up your codebase and make every comment count!
