---
description: "Run tests and help analyze and fix any failures"
---

# Smart Test Runner

I'll run your tests, analyze failures, and help fix issues with intelligent debugging assistance.

## 🔍 Test Discovery

```bash
echo "🔍 Discovering test configuration..."
echo ""

# Detect project type and test framework
TEST_FRAMEWORK=""
TEST_COMMAND=""

# JavaScript/TypeScript detection
if [ -f "package.json" ]; then
    echo "📦 Node.js project detected"
    
    # Check for test script in package.json
    if grep -q '"test"' package.json; then
        TEST_SCRIPT=$(grep '"test"' package.json | head -1 | sed 's/.*"test".*:.*"\(.*\)".*/\1/')
        echo "  ✓ Test script found: $TEST_SCRIPT"
        
        # Detect test framework from dependencies
        if grep -q '"jest"' package.json; then
            echo "  ✓ Jest framework detected"
            TEST_FRAMEWORK="jest"
        elif grep -q '"mocha"' package.json; then
            echo "  ✓ Mocha framework detected"
            TEST_FRAMEWORK="mocha"
        elif grep -q '"vitest"' package.json; then
            echo "  ✓ Vitest framework detected"
            TEST_FRAMEWORK="vitest"
        elif grep -q '"@playwright/test"' package.json; then
            echo "  ✓ Playwright framework detected"
            TEST_FRAMEWORK="playwright"
        elif grep -q '"cypress"' package.json; then
            echo "  ✓ Cypress framework detected"
            TEST_FRAMEWORK="cypress"
        fi
        
        # Detect package manager
        if [ -f "yarn.lock" ]; then
            TEST_COMMAND="yarn test"
            echo "  ✓ Using Yarn"
        elif [ -f "pnpm-lock.yaml" ]; then
            TEST_COMMAND="pnpm test"
            echo "  ✓ Using pnpm"
        else
            TEST_COMMAND="npm test"
            echo "  ✓ Using npm"
        fi
    fi
fi

# Python detection
if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
    echo "🐍 Python project detected"
    
    if [ -f "pytest.ini" ] || [ -f "setup.cfg" ] || grep -q "pytest" requirements.txt 2>/dev/null; then
        echo "  ✓ Pytest framework detected"
        TEST_FRAMEWORK="pytest"
        TEST_COMMAND="pytest"
    elif [ -d "tests" ] && ls tests/*.py 2>/dev/null | grep -q test; then
        echo "  ✓ Unittest framework likely"
        TEST_FRAMEWORK="unittest"
        TEST_COMMAND="python -m unittest discover"
    fi
fi

# Go detection
if [ -f "go.mod" ]; then
    echo "🐹 Go project detected"
    TEST_FRAMEWORK="go test"
    TEST_COMMAND="go test ./..."
    echo "  ✓ Using Go's built-in testing"
fi

# Rust detection
if [ -f "Cargo.toml" ]; then
    echo "🦀 Rust project detected"
    TEST_FRAMEWORK="cargo test"
    TEST_COMMAND="cargo test"
    echo "  ✓ Using Cargo test"
fi

# Java detection
if [ -f "pom.xml" ]; then
    echo "☕ Maven project detected"
    TEST_FRAMEWORK="maven"
    TEST_COMMAND="mvn test"
elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    echo "☕ Gradle project detected"
    TEST_FRAMEWORK="gradle"
    TEST_COMMAND="./gradlew test"
fi

# .NET detection
if [ -f "*.csproj" ] || [ -f "*.sln" ]; then
    echo "🔷 .NET project detected"
    TEST_FRAMEWORK="dotnet"
    TEST_COMMAND="dotnet test"
fi

echo ""
echo "Test command: ${TEST_COMMAND:-Not detected}"
echo ""

# Find test files
echo "📂 Locating test files..."
TEST_FILES=$(find . -type f \( \
    -name "*.test.js" -o -name "*.spec.js" -o \
    -name "*.test.ts" -o -name "*.spec.ts" -o \
    -name "*.test.jsx" -o -name "*.spec.jsx" -o \
    -name "*.test.tsx" -o -name "*.spec.tsx" -o \
    -name "test_*.py" -o -name "*_test.py" -o \
    -name "*_test.go" -o -name "*.rs" -path "*/tests/*" \
    \) -not -path "*/node_modules/*" -not -path "*/vendor/*" 2>/dev/null | head -20)

if [ -n "$TEST_FILES" ]; then
    FILE_COUNT=$(echo "$TEST_FILES" | wc -l)
    echo "Found $FILE_COUNT test file(s):"
    echo "$TEST_FILES" | head -5 | sed 's/^/  • /'
    if [ $FILE_COUNT -gt 5 ]; then
        echo "  ... and $((FILE_COUNT - 5)) more"
    fi
else
    echo "⚠️  No test files found in standard locations"
fi

echo ""
```

## 🧪 Test Execution

```bash
echo "🚀 Running tests..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Set up test environment
export CI=true  # Run in CI mode for consistent output
export NODE_ENV=test
export FORCE_COLOR=1  # Enable colored output

# Run tests with appropriate verbosity and formatting
if [ -n "$TEST_COMMAND" ]; then
    # Capture both stdout and stderr, preserve exit code
    TEST_OUTPUT_FILE=$(mktemp)
    TEST_EXIT_CODE=0
    
    # Run with coverage if available
    if [[ "$TEST_FRAMEWORK" == "jest" ]]; then
        $TEST_COMMAND --coverage --no-cache --verbose 2>&1 | tee $TEST_OUTPUT_FILE
        TEST_EXIT_CODE=${PIPESTATUS[0]}
    elif [[ "$TEST_FRAMEWORK" == "pytest" ]]; then
        $TEST_COMMAND -v --tb=short --color=yes 2>&1 | tee $TEST_OUTPUT_FILE
        TEST_EXIT_CODE=${PIPESTATUS[0]}
    elif [[ "$TEST_FRAMEWORK" == "go test" ]]; then
        $TEST_COMMAND -v -cover 2>&1 | tee $TEST_OUTPUT_FILE
        TEST_EXIT_CODE=${PIPESTATUS[0]}
    else
        $TEST_COMMAND 2>&1 | tee $TEST_OUTPUT_FILE
        TEST_EXIT_CODE=${PIPESTATUS[0]}
    fi
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ $TEST_EXIT_CODE -eq 0 ]; then
        echo "✅ All tests passed!"
    else
        echo "❌ Tests failed with exit code: $TEST_EXIT_CODE"
        echo ""
        echo "Analyzing failures..."
    fi
else
    echo "❌ No test command found. Please specify how to run tests."
    exit 1
fi
```

## 🔬 Failure Analysis

If tests failed, I'll analyze the output to identify:

```bash
if [ $TEST_EXIT_CODE -ne 0 ]; then
    echo ""
    echo "🔍 Analyzing test failures..."
    echo ""
    
    # Parse different test output formats
    case "$TEST_FRAMEWORK" in
        "jest"|"vitest")
            # Parse Jest/Vitest output
            echo "📊 Jest/Vitest Failure Summary:"
            grep -E "FAIL|✕|●" $TEST_OUTPUT_FILE | head -10
            
            # Extract specific failures
            echo ""
            echo "Failed tests:"
            grep -A 5 "● " $TEST_OUTPUT_FILE | head -30
            ;;
            
        "pytest")
            # Parse pytest output
            echo "📊 Pytest Failure Summary:"
            grep -E "FAILED|ERROR" $TEST_OUTPUT_FILE | head -10
            
            # Extract assertion details
            echo ""
            echo "Assertion failures:"
            grep -A 10 "AssertionError" $TEST_OUTPUT_FILE | head -30
            ;;
            
        "mocha")
            # Parse Mocha output
            echo "📊 Mocha Failure Summary:"
            grep -E "failing|✖" $TEST_OUTPUT_FILE | head -10
            ;;
            
        *)
            # Generic failure parsing
            echo "📊 Test Failure Summary:"
            grep -iE "fail|error|assert" $TEST_OUTPUT_FILE | head -20
            ;;
    esac
    
    rm -f $TEST_OUTPUT_FILE
fi
```

## 🔧 Intelligent Fix Suggestions

Based on the failure patterns, I'll provide specific fixes:

### Common Failure Patterns

#### 1. **Assertion Failures**

```javascript
// ❌ Test failure:
Expected: "Hello World"
Received: "Hello world"

// 🔧 Fix suggestion:
// The test is case-sensitive. Either:
// 1. Fix the implementation to match expected case
// 2. Use case-insensitive comparison: expect(result.toLowerCase()).toBe("hello world")
```

#### 2. **Async/Timing Issues**

```javascript
// ❌ Test failure:
Timeout - Async callback was not invoked within 5000ms

// 🔧 Fix suggestions:
// 1. Increase timeout: jest.setTimeout(10000)
// 2. Add proper async handling:
test('async test', async () => {
    await expect(fetchData()).resolves.toBe('data');
});
// 3. Check for missing await keywords
```

#### 3. **Mock/Stub Issues**

```javascript
// ❌ Test failure:
Cannot read property 'get' of undefined

// 🔧 Fix suggestion:
// Missing mock setup. Add:
jest.mock('./api', () => ({
    get: jest.fn().mockResolvedValue({ data: 'test' })
}));
```

#### 4. **Environment Issues**

```bash
# ❌ Test failure:
Cannot find module 'xyz'

# 🔧 Fix suggestions:
# 1. Install missing dependency: npm install xyz
# 2. Check NODE_ENV is set to 'test'
# 3. Verify test setup files are loaded
```

#### 5. **Database/External Service Issues**

```javascript
// ❌ Test failure:
Connection refused: localhost:5432

// 🔧 Fix suggestions:
// 1. Ensure test database is running
// 2. Use test containers or in-memory database
// 3. Mock database calls for unit tests
```

## 📈 Test Metrics & Coverage

```bash
echo "📊 Test Metrics:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Extract test counts
if [[ "$TEST_FRAMEWORK" == "jest" ]] && [ -f "coverage/coverage-summary.json" ]; then
    echo "Coverage Report:"
    echo "  • Statements: $(jq '.total.statements.pct' coverage/coverage-summary.json)%"
    echo "  • Branches: $(jq '.total.branches.pct' coverage/coverage-summary.json)%"
    echo "  • Functions: $(jq '.total.functions.pct' coverage/coverage-summary.json)%"
    echo "  • Lines: $(jq '.total.lines.pct' coverage/coverage-summary.json)%"
    echo ""
    echo "Uncovered files:"
    jq -r '.[] | select(.statements.pct < 80) | .file' coverage/coverage-summary.json 2>/dev/null | head -5
fi

# Test performance
echo ""
echo "Performance:"
echo "  • Total duration: ${TEST_DURATION}s"
echo "  • Test suites: ${SUITE_COUNT}"
echo "  • Total tests: ${TEST_COUNT}"
echo "  • Passed: ${PASSED_COUNT}"
echo "  • Failed: ${FAILED_COUNT}"
echo "  • Skipped: ${SKIPPED_COUNT}"
```

## 🔄 Re-run Options

```bash
echo ""
echo "🔄 Re-run Options:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $TEST_EXIT_CODE -ne 0 ]; then
    echo "Would you like to:"
    echo "  1. Re-run all tests"
    echo "  2. Run only failed tests"
    echo "  3. Run tests in watch mode"
    echo "  4. Run with debugging output"
    echo "  5. Run specific test file"
    echo ""
    
    # Provide framework-specific re-run commands
    case "$TEST_FRAMEWORK" in
        "jest")
            echo "Commands:"
            echo "  • Run failed only: npm test -- --onlyFailures"
            echo "  • Watch mode: npm test -- --watch"
            echo "  • Debug: node --inspect-brk node_modules/.bin/jest --runInBand"
            echo "  • Specific file: npm test -- path/to/test.spec.js"
            ;;
        "pytest")
            echo "Commands:"
            echo "  • Run failed only: pytest --lf"
            echo "  • Verbose: pytest -vv"
            echo "  • Debug: pytest --pdb"
            echo "  • Specific file: pytest path/to/test_file.py"
            ;;
        "go test")
            echo "Commands:"
            echo "  • Verbose: go test -v ./..."
            echo "  • Specific package: go test ./pkg/..."
            echo "  • With race detection: go test -race ./..."
            ;;
    esac
fi
```

## 🐛 Debugging Assistance

For failing tests, I'll help you debug:

```bash
echo ""
echo "🐛 Debugging Failed Tests:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Offer to analyze specific test files
if [ $TEST_EXIT_CODE -ne 0 ]; then
    echo "I can help debug failures by:"
    echo "  1. Adding console.log statements to trace execution"
    echo "  2. Checking test setup and teardown"
    echo "  3. Verifying mock configurations"
    echo "  4. Analyzing async/await usage"
    echo "  5. Checking for race conditions"
    echo ""
    echo "I'll analyze the failing test files and suggest specific fixes..."
fi
```

## 🔍 Root Cause Analysis

I'll identify the root cause of failures:

### Categories of Issues

1. **Test Code Issues**
   - Incorrect assertions
   - Missing await keywords
   - Wrong mock setup
   - Timing dependencies

2. **Implementation Issues**
   - Actual bugs in code
   - Edge cases not handled
   - Incorrect logic

3. **Environment Issues**
   - Missing dependencies
   - Wrong Node version
   - Database not running
   - Environment variables

4. **Flaky Tests**
   - Race conditions
   - Time-dependent tests
   - External API dependencies
   - Random data issues

## 📝 Fix Implementation

For each identified issue, I'll:

1. **Show the exact problem**

   ```javascript
   // File: src/utils.test.js:15
   // ❌ Failing assertion:
   expect(formatDate('2024-01-01')).toBe('Jan 1, 2024')
   // Received: "January 1, 2024"
   ```

2. **Provide the fix**

   ```javascript
   // ✅ Fix option 1: Update test expectation
   expect(formatDate('2024-01-01')).toBe('January 1, 2024')
   
   // ✅ Fix option 2: Update implementation
   // In src/utils.js, change date format to use short month
   ```

3. **Verify the fix**

   ```bash
   # Re-run just this test to verify
   npm test -- utils.test.js
   ```

## 🎯 Next Steps

```bash
echo ""
echo "🎯 Recommended Actions:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ All tests passing! Consider:"
    echo "  • Add more test cases for edge scenarios"
    echo "  • Improve test coverage (current: ${COVERAGE}%)"
    echo "  • Set up continuous integration if not already done"
else
    echo "❌ Fix failing tests:"
    echo "  1. Apply suggested fixes to failing tests"
    echo "  2. Re-run tests to verify fixes"
    echo "  3. Commit changes once all tests pass"
    echo ""
    echo "📚 Resources:"
    echo "  • Debug mode: Add --inspect flag"
    echo "  • Isolate test: Run single test file"
    echo "  • Check logs: Review test output above"
fi
```

## 🚀 Advanced Features

### Parallel Test Execution

```bash
# Speed up test runs with parallel execution
if [[ "$TEST_FRAMEWORK" == "jest" ]]; then
    echo "Running tests in parallel with optimal workers..."
    npm test -- --maxWorkers=50%
fi
```

### Test Filtering

```bash
# Run specific test suites or patterns
echo "Filter options:"
echo "  • By name: npm test -- --testNamePattern='user.*login'"
echo "  • By file: npm test -- --testPathPattern='api'"
echo "  • By suite: npm test -- --selectProjects=unit"
```

### Continuous Testing

```bash
# Set up watch mode for development
echo "Starting test watcher..."
$TEST_COMMAND --watch --notify
```

Ready to run your tests and help fix any issues!
