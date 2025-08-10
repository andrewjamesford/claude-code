---
description: "Review code for potential security issues, bugs, and quality problems"
model: sonnet
---

# Code Review

I'll perform a comprehensive code review to identify security vulnerabilities, bugs, and quality issues in your codebase.

## Review Scope Configuration

```bash
echo "🔍 Initializing Code Review..."
echo ""

# Detect project type and size
if [ -d .git ]; then
    echo "📊 Project Statistics:"
    echo "  • Recent changes: $(git diff --name-only HEAD~5..HEAD 2>/dev/null | wc -l) files"
    echo "  • Language distribution:"
    git ls-files | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -5 | sed 's/^/    /'
    echo ""
    
    # Focus on recently modified files for targeted review
    REVIEW_SCOPE="recent"
    FILES_TO_REVIEW=$(git diff --name-only HEAD~10..HEAD 2>/dev/null | grep -E '\.(js|jsx|ts|tsx|py|java|go|rb|php|cs|cpp|c|rs|swift|kt)$')
else
    REVIEW_SCOPE="all"
    FILES_TO_REVIEW=$(find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" -o -name "*.go" \) -not -path "*/node_modules/*" -not -path "*/vendor/*" | head -100)
fi

echo "Review scope: $REVIEW_SCOPE"
echo "Files to review: $(echo "$FILES_TO_REVIEW" | wc -l)"
echo ""
```

## 🛡️ Security Analysis

### Critical Security Checks:

#### 1. **Credential & Secret Detection**
```javascript
// Scanning for:
- API keys: /api[_-]?key/i
- Passwords: /password\s*=\s*["'](?!.*\{)/
- Tokens: /token\s*[:=]\s*["'][^"']+["']/
- Private keys: /BEGIN\s+(RSA|DSA|EC|OPENSSH)\s+PRIVATE\s+KEY/
- AWS credentials: /AKIA[0-9A-Z]{16}/
- Database URLs with passwords: /[^/]*:\/\/[^:]*:[^@]*@/

// Example issues:
const API_KEY = "sk-1234567890abcdef"; // ❌ Hardcoded API key
const password = "admin123"; // ❌ Hardcoded password
const dbUrl = "postgres://user:pass@localhost/db"; // ❌ Credentials in URL
```

#### 2. **Injection Vulnerabilities**
```javascript
// SQL Injection risks:
db.query(`SELECT * FROM users WHERE id = ${userId}`); // ❌ Unsafe
db.query("SELECT * FROM users WHERE id = ?", [userId]); // ✅ Safe

// Command Injection:
exec(`ls ${userInput}`); // ❌ Dangerous
execFile('ls', [userInput]); // ✅ Safer

// Path Traversal:
fs.readFile(`./uploads/${filename}`); // ❌ No validation
fs.readFile(path.join('./uploads', path.basename(filename))); // ✅ Safer

// XSS Prevention:
innerHTML = userContent; // ❌ XSS risk
textContent = userContent; // ✅ Safe
```

#### 3. **Authentication & Authorization**
```javascript
// Missing auth checks:
router.get('/admin', (req, res) => { // ❌ No auth middleware
    // Admin functionality
});

router.get('/admin', authenticate, authorize('admin'), (req, res) => { // ✅
    // Protected route
});

// Weak session management:
session.cookie.secure = false; // ❌ Not HTTPS-only
session.cookie.httpOnly = false; // ❌ Accessible via JS
```

#### 4. **Cryptography Issues**
```javascript
// Weak algorithms:
crypto.createHash('md5'); // ❌ MD5 is broken
crypto.createHash('sha256'); // ✅ Better

// Insecure randomness:
Math.random(); // ❌ Not cryptographically secure
crypto.randomBytes(32); // ✅ Secure

// Weak key sizes:
generateKeyPair('rsa', { modulusLength: 1024 }); // ❌ Too small
generateKeyPair('rsa', { modulusLength: 2048 }); // ✅ Minimum recommended
```

## 🐛 Bug Detection

### Common Bug Patterns:

#### 1. **Null/Undefined Handling**
```javascript
// Potential crashes:
user.name.toLowerCase(); // ❌ Can crash if user or name is null
user?.name?.toLowerCase(); // ✅ Safe navigation

// Array access:
const first = items[0].id; // ❌ Assumes array has items
const first = items[0]?.id; // ✅ Defensive

// Default values:
function process(options) {
    const limit = options.limit; // ❌ Crashes if options undefined
    const limit = options?.limit ?? 10; // ✅ Safe with default
}
```

#### 2. **Async/Promise Issues**
```javascript
// Unhandled rejections:
async function fetchData() {
    const data = await api.get('/data'); // ❌ No error handling
    return data;
}

// Missing await:
async function process() {
    fetchData(); // ❌ Promise not awaited
    console.log('Done'); // Logs before fetch completes
}

// Promise.all failures:
await Promise.all(promises); // ❌ Fails if any reject
await Promise.allSettled(promises); // ✅ Handles individual failures
```

#### 3. **Type Coercion Bugs**
```javascript
// Dangerous comparisons:
if (value == false) // ❌ Matches 0, "", [], etc.
if (value === false) // ✅ Strict comparison

// Number parsing:
parseInt(userInput); // ❌ No radix, can be octal
parseInt(userInput, 10); // ✅ Explicit base 10

// Array/Object checks:
if (data.length) // ❌ Fails for {length: 0}
if (Array.isArray(data) && data.length) // ✅ Type-safe
```

#### 4. **Resource Management**
```javascript
// Memory leaks:
element.addEventListener('click', handler); // ❌ Never removed
// Should have: element.removeEventListener('click', handler);

// File handles:
const file = fs.openSync('data.txt', 'r'); // ❌ Never closed
// Should have: fs.closeSync(file);

// Database connections:
const conn = await db.connect(); // ❌ Connection leak
// Should have: try/finally with conn.release()
```

## ⚡ Performance Analysis

### Performance Anti-patterns:

#### 1. **Algorithm Complexity**
```javascript
// O(n²) when O(n) is possible:
for (let i = 0; i < items.length; i++) {
    if (otherItems.includes(items[i])) { // ❌ O(n²)
        // ...
    }
}

// Better with Set:
const otherSet = new Set(otherItems);
for (const item of items) {
    if (otherSet.has(item)) { // ✅ O(n)
        // ...
    }
}
```

#### 2. **Database Query Issues**
```javascript
// N+1 queries:
const users = await User.findAll();
for (const user of users) {
    user.posts = await Post.findByUser(user.id); // ❌ N queries
}

// Better with join:
const users = await User.findAll({ include: Post }); // ✅ 1 query
```

#### 3. **React/Frontend Issues**
```javascript
// Missing keys in lists:
items.map(item => <Item {...item} />); // ❌ No key

// Unnecessary re-renders:
onClick={() => setCount(count + 1)} // ❌ New function each render
onClick={handleClick} // ✅ Stable reference

// Large bundle imports:
import _ from 'lodash'; // ❌ Imports entire library
import debounce from 'lodash/debounce'; // ✅ Specific import
```

## 🎨 Code Quality Assessment

### Quality Metrics:

#### 1. **Complexity Analysis**
```
Function: processOrder()
├── Cyclomatic Complexity: 15 ⚠️ (threshold: 10)
├── Cognitive Complexity: 22 ⚠️ (threshold: 15)
├── Lines of Code: 87 ⚠️ (threshold: 50)
└── Recommendation: Split into smaller functions
```

#### 2. **Code Smells**
```javascript
// Long parameter lists:
function create(name, age, email, address, phone, company) { // ❌
function create(userDetails) { // ✅ Object parameter

// Magic numbers:
if (age > 17) { // ❌ What's 17?
const LEGAL_AGE = 18;
if (age >= LEGAL_AGE) { // ✅ Self-documenting

// Dead code:
if (false) { // ❌ Unreachable
    doSomething();
}

// Duplicate code blocks (DRY violation)
// God objects/functions doing too much
// Deeply nested code (> 3 levels)
```

#### 3. **Error Handling**
```javascript
// Silent failures:
try {
    riskyOperation();
} catch (e) {
    // ❌ Error swallowed
}

// Generic catches:
catch (e) {
    console.log("Error occurred"); // ❌ No context
}

// Better:
catch (error) {
    logger.error('Failed to process order', {
        error: error.message,
        orderId: order.id,
        stack: error.stack
    }); // ✅ Detailed logging
    throw new ProcessingError('Order processing failed', { cause: error });
}
```

## 📊 Review Report Format

### For each issue found:

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔴 CRITICAL: SQL Injection Vulnerability
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 File: src/api/users.js:45
├── Issue: Unsafe SQL query construction
├── Risk: Database compromise, data breach
├── CWE: CWE-89 (SQL Injection)
└── CVSS: 9.8 (Critical)

Current Code:
```javascript
const query = `SELECT * FROM users WHERE id = ${req.params.id}`;
db.execute(query);
```

Recommended Fix:
```javascript
const query = 'SELECT * FROM users WHERE id = ?';
db.execute(query, [req.params.id]);
```

References:
• OWASP: https://owasp.org/www-community/attacks/SQL_Injection
• Prevention: Use parameterized queries or prepared statements
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🎯 Severity Classification

Issues are classified by severity:

1. **🔴 CRITICAL** - Immediate attention required
   - Security vulnerabilities
   - Data loss risks
   - System crashes

2. **🟠 HIGH** - Should be fixed soon
   - Performance bottlenecks
   - Memory leaks
   - Logic errors

3. **🟡 MEDIUM** - Plan to fix
   - Code quality issues
   - Missing error handling
   - Technical debt

4. **🔵 LOW** - Nice to have
   - Style improvements
   - Minor optimizations
   - Documentation gaps

## 🔧 Auto-fix Capabilities

For certain issues, I can automatically fix them:

```bash
echo "🔧 Auto-fixable issues found:"
echo "  • Missing semicolons: 12"
echo "  • Unused variables: 8"
echo "  • Missing await keywords: 3"
echo "  • console.log statements: 15"
echo ""
echo "Would you like me to:"
echo "  1. Show fixes for review"
echo "  2. Apply safe fixes automatically"
echo "  3. Generate a patch file"
echo "  4. Create fix commits individually"
```

## 📈 Code Metrics Dashboard

```
═══════════════════════════════════════════════════════════
                    CODE REVIEW SUMMARY
═══════════════════════════════════════════════════════════

Overall Health Score: 72/100 (C+)

Security Score:      ██████░░░░  65/100
Bug Risk:           ████████░░  78/100
Performance:        ████████░░  82/100
Maintainability:    ██████░░░░  68/100
Test Coverage:      ████░░░░░░  42/100

Top Issues by Category:
┌─────────────────────────┬────────┬──────────┐
│ Category                │ Count  │ Severity │
├─────────────────────────┼────────┼──────────┤
│ SQL Injection Risk      │   3    │ CRITICAL │
│ Hardcoded Secrets       │   2    │ CRITICAL │
│ Missing Error Handling  │   15   │ HIGH     │
│ Performance Issues      │   8    │ MEDIUM   │
│ Code Complexity         │   12   │ MEDIUM   │
└─────────────────────────┴────────┴──────────┘

Trend (vs. last review):
  Security:        ↑ +5 (improved)
  Bugs:           ↓ -3 (degraded)
  Performance:    → 0 (unchanged)
```

## 🚀 Next Steps

Based on the review, here's your action plan:

### Immediate (Critical Security):
1. Fix SQL injection in users.js:45
2. Remove hardcoded API key in config.js:12
3. Add authentication to admin routes

### Short-term (This Sprint):
1. Add error handling to async functions
2. Fix memory leak in EventListener
3. Refactor complex processOrder() function

### Long-term (Technical Debt):
1. Increase test coverage to 80%
2. Implement proper logging strategy
3. Set up security scanning in CI/CD

## 🔄 Continuous Monitoring

I can also set up continuous monitoring:

```yaml
# .github/workflows/code-review.yml
- Regular security scans
- Complexity trending
- Dependency vulnerability checks
- Performance regression detection
```

Ready to begin the comprehensive code review. Should I focus on any particular area or concern?