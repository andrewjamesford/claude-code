---
description: "Fix import statements that broke after moving or renaming files"
---

# Fix Broken Imports

I'll help fix import statements that broke after moving or renaming files, supporting multiple languages and import styles.

## Initial Analysis

### 1. Project Detection

```md
Scanning project structure...
├── Detecting language(s) and frameworks
├── Identifying build configuration files
├── Analyzing import conventions used
└── Mapping source directories and aliases
```

I'll detect:

- **Languages**: JavaScript/TypeScript, Python, Java, Go, Rust, C/C++, PHP, Ruby, etc.
- **Module Systems**: ES6, CommonJS, Python modules, Java packages, etc.
- **Path Aliases**: tsconfig paths, webpack aliases, module resolution configs
- **Import Styles**: relative, absolute, aliased, barrel exports

### 2. Import Pattern Recognition

Based on your language, I'll look for:

**JavaScript/TypeScript:**

```javascript
import { Component } from './components/Button';     // ES6
const utils = require('../utils/helpers');           // CommonJS
import * as React from 'react';                      // Namespace
export { default } from './Button';                  // Re-exports
import type { Props } from './types';                // Type imports
```

**Python:**

```python
from app.models import User                          # Absolute
from ..utils import helper                           # Relative
import sys, os                                       // Multiple
from . import module                                 // Package
```

**Java/Kotlin:**

```java
import com.example.models.User;                      // Package
import static org.junit.Assert.*;                    // Static
import com.example.utils.*;                          // Wildcard
```

**Go:**

```go
import "github.com/user/repo/pkg"                    // External
import "./internal/utils"                            // Internal
import _ "database/sql"                              // Side-effect
```

## Broken Import Detection

### Scanning Strategy

1. **Parse All Source Files**
   - Extract import statements with their exact syntax
   - Note the importing file's location
   - Track import resolution context

2. **Verify Each Import**

   ```md
   For each import:
   ├── Resolve the expected path
   ├── Check if target exists
   ├── If missing, mark as broken
   └── Store original context for fixes
   ```

3. **Categorize Issues**
   - **File Moved**: Target exists elsewhere
   - **File Renamed**: Similar file with different name
   - **File Deleted**: No matching file found
   - **Path Typo**: Near-match suggests typo
   - **Case Sensitivity**: Wrong case on case-sensitive systems

## Smart Resolution

### File Discovery Algorithm

```md
1. Exact Name Match
   └── Search for exact filename in new locations

2. Similarity Matching (85%+ match)
   ├── Levenshtein distance for typos
   ├── Case-insensitive comparison
   └── Common rename patterns (index → main, etc.)

3. Content Matching
   ├── Match exported symbols/classes
   ├── Compare file signatures
   └── Analyze git history if available

4. Context Clues
   ├── Check sibling imports
   ├── Analyze import patterns
   └── Consider common refactoring patterns
```

### Resolution Priority

1. **Same Directory** - File renamed in place
2. **Sibling Directories** - Moved to parallel folder
3. **Parent/Child** - Moved up or down hierarchy  
4. **Common Locations** - src/, lib/, components/, etc.
5. **Git History** - Check recent moves/renames

## Fix Application

### For Each Broken Import

```typescript
// 📍 File: src/components/Dashboard.tsx
// ❌ Broken Import:
import { Button } from './ui/Button';
// 🔍 Analysis: File not found at './ui/Button'

// 🎯 Found Matches:
// 1. src/components/shared/Button.tsx (95% confidence - exact name match)
// 2. src/design-system/Button/index.tsx (75% confidence - exports match)

// ✅ Applying Fix #1:
import { Button } from './shared/Button';

// 📝 Validation:
// - Export names match ✓
// - TypeScript types compatible ✓
// - No circular dependencies ✓
```

### Handling Complex Cases

**Barrel Exports:**

```typescript
// If the import was from an index file
import { Button, Input } from './components';

// I'll check if components/index.ts needs updating
// Or if individual imports are now needed:
import { Button } from './components/Button';
import { Input } from './components/Input';
```

**Monorepo/Workspace:**

```typescript
// Handle cross-package imports
import { utils } from '@myapp/shared';
// Check workspace configuration and package.json
```

**Dynamic Imports:**

```javascript
// Handle dynamic and lazy imports
const Component = lazy(() => import('./Component'));
// Apply same resolution logic
```

## Interactive Resolution

When multiple matches exist or confidence is low:

```md
🤔 Ambiguous import detected:
   File: src/pages/Home.tsx
   Import: import { useAuth } from '../hooks/useAuth';

   Possible matches:
   1. src/hooks/auth/useAuth.ts
      - Exports: useAuth, useAuthState
      - Last modified: 2 hours ago
      
   2. src/features/auth/hooks/useAuth.ts  
      - Exports: useAuth, AuthProvider
      - Last modified: 1 day ago
      
   3. src/lib/auth/useAuth.ts
      - Exports: useAuth (deprecated)
      - Last modified: 1 week ago

   Context: This file also imports from '../features/auth'
   
   Which file should be imported? (1-3, or 's' to skip):
```

## Batch Operations

### Intelligent Grouping

- **Same Fix Pattern**: Apply similar fixes together
- **Related Files**: Fix imports in feature groups
- **Dependency Order**: Fix in dependency order to avoid cascading issues

### Preview Mode

```md
📊 Import Fix Summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total broken imports found: 23
Automatically fixable: 19
Requiring confirmation: 3
Unresolvable: 1

Proposed fixes by confidence:
● High (>90%): 15 imports
● Medium (70-90%): 4 imports  
● Low (<70%): 3 imports

Would you like to:
1. Apply all high-confidence fixes
2. Review each fix
3. Preview all changes
4. Generate fix report
```

## Validation & Safety

### Pre-fix Validation

- **Circular Dependencies**: Detect and prevent
- **Type Compatibility**: Verify exports match expected types
- **Side Effects**: Check for module initialization dependencies
- **Build Impact**: Estimate build/compile impact

### Post-fix Verification

```bash
# Run validation appropriate to project:
- TypeScript: tsc --noEmit
- JavaScript: ESLint import plugin
- Python: pylint/mypy
- Java: javac compilation
- Go: go build
```

## Advanced Features

### 1. Alias Resolution

```javascript
// Resolve path aliases from config
import { Button } from '@components/Button';
// Check: tsconfig.json, webpack.config.js, .babelrc, etc.
```

### 2. Import Optimization

```javascript
// While fixing, also optimize:
// Before: import { default as React, useState, useEffect } from 'react';
// After: import React, { useState, useEffect } from 'react';
```

### 3. Git Integration

```bash
# Use git history to track moves
git log --follow --name-only --format="" -- "**/Button.*"
```

### 4. Update References

- Update corresponding export statements
- Fix test file imports
- Update documentation links
- Adjust bundle configurations

## Error Recovery

### For Unresolvable Imports

```typescript
// ⚠️ Could not resolve:
import { LegacyComponent } from './old/LegacyComponent';

// Suggested actions:
// 1. File may be deleted - check git history
// 2. May need installation - check package.json
// 3. Could be generated - check build scripts
// 4. Manual intervention required

// Adding TODO comment:
// TODO: Fix import - file './old/LegacyComponent' not found
import { LegacyComponent } from './old/LegacyComponent';
```

## Final Report

```md
✅ Import Fix Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Fixed: 19/23 broken imports
Time: 3.2 seconds

By Category:
● Moved files: 12
● Renamed files: 5  
● Path corrections: 2
● Unresolved: 4

Modified Files:
✓ src/components/Dashboard.tsx (3 imports)
✓ src/pages/Home.tsx (2 imports)
✓ src/utils/api.ts (1 import)
... and 7 more

Next Steps:
1. Review unresolved imports manually
2. Run your test suite
3. Rebuild the project
4. Commit the changes

Need help with unresolved imports? Run with --verbose flag.
```

## Configuration Support

I'll respect your project's import preferences:

- **Sort Order**: Alphabetical, grouped, or custom
- **Quote Style**: Single or double quotes
- **Trailing Commas**: Preserve your style
- **Import Grouping**: External, internal, relative
- **Line Length**: Respect prettier/eslint settings

Ready to scan and fix your broken imports!
