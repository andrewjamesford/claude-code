---
description: "Find and fix loose type declarations to improve code type safety"
---

# Cleanup Loose Types

I'll help improve type safety in your code by finding and fixing loose type declarations.

## Initial Analysis

First, let me analyze your project structure:

1. **Language Detection**: I'll identify your primary language(s) and their type system capabilities
2. **Configuration Check**: Look for TypeScript/Flow configs, linting rules, or type checking settings
3. **Scope Assessment**: Determine which files to analyze based on your project structure

## Type Issues I'll Target

### Critical Issues (Priority 1)

- `any` types in TypeScript/Flow
- Implicit `any` parameters in functions
- Missing return type annotations
- Untyped exported functions/constants
- Type assertions without validation (`as` casts, `!` assertions)

### Common Issues (Priority 2)

- Overly broad types (`object`, `Function`, raw arrays `[]`)
- Union types that could be narrowed
- Missing generic constraints
- Untyped event handlers and callbacks
- Props without proper typing (React/Vue/Angular)

### Enhancement Opportunities (Priority 3)

- String literals that could be literal types or enums
- Number types that could be more specific
- Arrays that could use readonly or tuple types
- Objects that could use interfaces or type aliases
- Functions that could benefit from overloads

## Analysis Process

For each file, I'll:

1. **Parse and understand context**
   - How values are initialized
   - How they're used throughout the code
   - What operations are performed on them
   - What they're passed to or returned from

2. **Infer better types**
   - Analyze usage patterns
   - Check for consistent shapes/values
   - Look for discriminated unions opportunities
   - Consider nullability and optionality

3. **Validate improvements**
   - Ensure no breaking changes
   - Check against existing tests
   - Verify with language server if possible

## Output Format

For each issue found, I'll provide:

```typescript
// 📍 Location: path/to/file.ts:line
// ⚠️  Issue: [Description of the problem]
// 📊 Usage Analysis: [How the value is used]

// ❌ Current:
function processData(data: any) {
  return data.items.map(item => item.value);
}

// ✅ Suggested:
interface DataItem {
  value: string;
}

interface ProcessDataInput {
  items: DataItem[];
}

function processData(data: ProcessDataInput): string[] {
  return data.items.map(item => item.value);
}

// 💡 Reasoning: [Why this change improves type safety]
```

## Interactive Workflow

1. **Discovery Phase**: I'll scan and categorize all type issues
2. **Priority Review**: Show you a summary grouped by severity
3. **Batch Processing**: Handle similar issues together for efficiency
4. **Progressive Enhancement**: Start with safe changes, then tackle complex ones
5. **Validation**: Run type checking after each batch of changes

## Configuration Options

Would you like me to:

- Focus on specific directories or file patterns?
- Prioritize certain types of issues?
- Apply stricter or more lenient type standards?
- Generate a type definition file for untyped libraries?
- Add JSDoc comments for better IDE support?
- Create a migration plan for gradual type improvement?

## Safety Guarantees

I will:

- ✅ Preserve all existing functionality
- ✅ Maintain backward compatibility
- ✅ Follow your project's style guide
- ✅ Explain each change clearly
- ✅ Create atomic commits if requested
- ❌ Never make changes without explanation
- ❌ Never introduce breaking changes without warning

Ready to begin? I'll start by scanning your codebase to identify type improvement opportunities.

## Additional Features

### Type Coverage Report

I can generate a report showing:

- Current type coverage percentage
- Files with the most type issues
- Estimated effort for full type safety
- Risk assessment for each change

### Migration Strategy

For large codebases, I can create:

- Phased migration plan
- Type definition files for gradual adoption
- Automated refactoring scripts
- Documentation for team adoption

Let me know if you'd like me to start with a specific area or perform a full project scan!
