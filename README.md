```
  ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗     ██████╗ ██████╗ ██████╗ ███████╗
 ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝
 ██║     ██║     ███████║██║   ██║██║  ██║█████╗      ██║     ██║   ██║██║  ██║█████╗  
 ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝      ██║     ██║   ██║██║  ██║██╔══╝  
 ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗    ╚██████╗╚██████╔╝██████╔╝███████╗
  ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝

                        ┌─────────────────────────────────────────────┐
                        │     Andrew's config for Claude Code.        │
                        └─────────────────────────────────────────────┘

    ╔═════════════════════════════════════════════════════════════════════════╗
    ║                              ENHANCED WORKFLOWS                         ║
    ╠═════════════════════════════════════════════════════════════════════════╣
    ║                                                                         ║
    ║     PRD (Product Requirements Document)                                 ║
    ║     • Structured requirement gathering and analysis                     ║
    ║     • Feature specification and user story generation                   ║
    ║     • Technical requirements and acceptance criteria                    ║
    ║     • Stakeholder alignment and project planning                        ║
    ║                                                                         ║
    ║     TDD (Test-Driven Development)                                       ║
    ║     • Red-Green-Refactor cycle automation                               ║
    ║     • Test case generation and implementation                           ║
    ║     • Code quality assurance and regression testing                     ║
    ║     • Continuous integration and deployment support                     ║
    ║                                                                         ║
    ╚═════════════════════════════════════════════════════════════════════════╝

    ┌────────────────────────────────────────────────────────────────────────┐
    │ 🚀 Accelerate Development • 🎨 Clean Code • 🔧 Intelligent Automation   │
    └────────────────────────────────────────────────────────────────────────┘

                           Ready to transform your workflow?
                              Start coding with Claude! 🤖
```

# Claude Code Config Files
å
This repository contains configuration files and supporting documentation for using Claude (Anthropic's AI assistant) in coding workflows.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Configuration Structure](#configuration-structure)
- [Customizing Your Config](#customizing-your-config)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)
- [Credits](#credits)
***



## Overview

This repository contains some examples of claude commands, agents and configuration that I use. Take the pieces you want to use and place in your .claude folder either in your home directory or in the home of your project.

## Project Structure

```
claude-code/
├── CLAUDE.md                # Project instructions and Clean Code principles
├── LICENSE                  # Apache 2.0 license
├── README.md               # This file
├── claude_desktop_config.json  # Claude desktop configuration
├── settings.json           # Project settings
├── agents/                 # Agent configurations
│   ├── code-review-specialist.md
│   ├── gemini-context-expert.md
│   ├── qa-test-engineer.md
│   └── software-architect.md
└── commands/               # Custom command definitions
    ├── chores/            # Code maintenance commands
    │   ├── cleanup-types.md
    │   ├── commit.md
    │   ├── fix-imports.md
    │   ├── format.md
    │   ├── remove-comments.md
    │   ├── review.md
    │   └── test.md
    ├── prd/               # Product requirement document commands
    │   ├── prd-create.md
    │   ├── prd-generate-tasks.md
    │   └── prd-process-task-list.md
    └── tdd/               # Test-driven development commands
        ├── tdd-execute.md
        └── tdd-test-cases.md
```

## PRD (Product Requirements Document) Process

The PRD workflow provides a structured approach to feature development, from initial requirements gathering through implementation. This three-phase process ensures clear communication and systematic implementation.

### Phase 1: Create PRD (`prd-create.md`)

Creates a comprehensive Product Requirements Document based on user requirements:

1. **Initial Input**: User provides a brief feature description
2. **Clarification**: AI asks targeted questions to understand:
   - Problem being solved and main goals
   - Target users and user stories
   - Core functionality and acceptance criteria
   - Scope boundaries (what's included/excluded)
   - Design and technical considerations
3. **PRD Generation**: Creates structured document with:
   - Introduction and goals
   - User stories and functional requirements
   - Non-goals (out of scope items)
   - Design/technical considerations
   - Success metrics
   - Open questions
4. **Output**: Saves as `prd-[feature-name].md` in `/tasks` directory

### Phase 2: Generate Tasks (`prd-generate-tasks.md`)

Converts the PRD into actionable development tasks:

1. **PRD Analysis**: Reviews the PRD and existing codebase
2. **Parent Tasks**: Generates ~5 high-level tasks
3. **User Confirmation**: Waits for "Go" before proceeding
4. **Sub-tasks**: Breaks down each parent task into specific steps
5. **File Mapping**: Identifies files to create/modify
6. **Output**: Saves as `tasks-[prd-file-name].md` with:
   - Relevant files list
   - Numbered task hierarchy (1.0, 1.1, 1.2, etc.)
   - Checkbox format for tracking

### Phase 3: Process Tasks (`prd-process-task-list.md`)

Manages the implementation workflow:

1. **Sequential Execution**: Works on one sub-task at a time
2. **Progress Tracking**: Marks completed items with `[x]`
3. **Parent Task Completion**: When all sub-tasks done:
   - Runs full test suite
   - Stages changes if tests pass
   - Commits with descriptive message
   - Marks parent task complete
4. **User Approval**: Pauses after each sub-task for confirmation
5. **File Updates**: Maintains accurate "Relevant Files" section

### Example Workflow

```bash
# Step 1: Create PRD
/prd-create "I need a user authentication system"
# AI asks clarifying questions, generates prd-authentication.md

# Step 2: Generate task list
/prd-generate-tasks prd-authentication.md
# AI creates tasks-prd-authentication.md with implementation steps

# Step 3: Execute tasks
/prd-process-task-list tasks-prd-authentication.md
# AI implements each task systematically with user approval
```

This structured approach ensures features are well-documented, properly planned, and systematically implemented with clear progress tracking.

## TDD (Test-Driven Development) Process

The TDD workflow implements Kent Beck's canonical Red-Green-Refactor cycle, ensuring high-quality code through comprehensive test coverage and disciplined development practices.

### Phase 1: Generate Test Cases (`tdd-test-cases.md`)

Creates comprehensive test scenarios before implementation:

1. **Information Gathering**: Collects requirements about:
   - Feature functionality and acceptance criteria
   - Expected inputs/outputs
   - Edge cases and boundary conditions
   - Error handling requirements
   - Testing framework preferences

2. **Test List Creation**: Generates tests covering:
   - Happy path scenarios
   - Input validation
   - Boundary conditions and edge cases
   - Error conditions
   - Integration points

3. **Test Structure**: Provides tests using:
   - AAA Pattern (Arrange-Act-Assert)
   - Given-When-Then (BDD-style)
   - Descriptive naming conventions

4. **Output**: Saves as `tdd-[feature-name].md` in `/tasks` directory with:
   - Feature analysis
   - Prioritized test list
   - Implementation order recommendations
   - Concrete test code examples

### Phase 2: Execute TDD Cycle (`tdd-execute.md`)

Guides systematic implementation through Red-Green-Refactor:

#### RED Phase - Write Failing Test
- Select one test from the list
- Write minimal test code describing expected behavior
- Use descriptive test names
- Run test to confirm it fails for expected reasons
- Verify failure message is clear and helpful

#### GREEN Phase - Make Test Pass
- Write simplest possible code to pass the test
- Use hard-coding or obvious implementation as needed
- Focus only on current test
- Run all tests to ensure nothing breaks
- Commit working code before proceeding

#### REFACTOR Phase - Improve Design
- Look for code duplication to eliminate
- Improve variable and method names
- Extract methods or classes where appropriate
- Apply design patterns if beneficial
- Run tests after each refactoring step
- Stop when code is clean and readable

### Key TDD Principles

1. **Test First**: Never write production code without a failing test
2. **Minimal Implementation**: Write just enough code to pass current test
3. **Fast Feedback**: Keep tests running quickly
4. **Single Focus**: Work on one test at a time
5. **Behavior Over Implementation**: Test what code does, not how
6. **Independent Tests**: Each test runs in isolation

### Implementation Strategies

- **Fake It**: Return hard-coded values initially
- **Obvious Implementation**: Write straightforward solution when clear
- **Triangulation**: Add more tests to drive generalization

### Example TDD Workflow

```bash
# Step 1: Generate test cases
/tdd-test-cases "Create a calculator with basic operations"
# AI creates tdd-calculator.md with comprehensive test scenarios

# Step 2: Execute TDD cycle
/tdd-execute tdd-calculator.md
# AI guides through Red-Green-Refactor for each test

# Cycle example:
# RED: Write test for "add(2, 3) should return 5"
# GREEN: Implement minimal add() function
# REFACTOR: Clean up code structure
# Repeat for next test...
```

### Common Pitfalls to Avoid

**RED Phase:**
- Writing tests that always pass
- Testing multiple behaviors in single test
- Overly complex test setup

**GREEN Phase:**
- Writing more code than needed
- Mixing refactoring with implementation
- Breaking existing tests

**REFACTOR Phase:**
- Adding new functionality
- Refactoring without test safety net
- Over-engineering solutions

The TDD process ensures robust, well-tested code with clear specifications, minimal but sufficient implementations, and maintainable design driven by test requirements.

## Chores Commands

The chores folder contains maintenance and code quality commands to keep your codebase clean, secure, and well-formatted.

### Available Chores

#### `/cleanup-types` - Type Safety Improvement
Finds and fixes loose type declarations to improve code type safety:
- **Targets**: `any` types, missing return types, untyped functions
- **Languages**: TypeScript, Flow, and typed JavaScript
- **Features**: 
  - Priority-based fixing (critical → enhancement)
  - Usage pattern analysis for better type inference
  - Safety guarantees with no breaking changes
  - Type coverage reporting

#### `/commit` - Intelligent Git Commits
Creates meaningful commit messages following project conventions:
- **Auto-detects**: Conventional commits, bracket format, ticket references
- **Analyzes**: Change patterns, file types, commit history
- **Features**:
  - Smart staging of modified files
  - Pre-commit hook validation
  - Convention-aware message generation
  - Large file and sensitive data warnings

#### `/fix-imports` - Import Statement Repair
Fixes broken import statements after file moves/renames:
- **Supports**: JavaScript/TypeScript, Python, Java, Go, Rust
- **Smart Resolution**: Similarity matching, content analysis, git history
- **Features**:
  - Path alias resolution
  - Barrel export handling
  - Circular dependency detection
  - Batch operations with confidence scoring

#### `/format` - Code Formatting
Auto-formats code using project's configured formatter:
- **Formatters**: Prettier, Biome, ESLint, Black, gofmt, rustfmt
- **Features**:
  - Multi-language support in single run
  - Git-based file targeting (changed files only)
  - Safety backups with git stash
  - Configuration detection and validation

#### `/remove-comments` - Comment Cleanup
Removes redundant comments while preserving valuable documentation:
- **Removes**: Obvious comments that restate code
- **Preserves**: WHY explanations, warnings, TODOs, business logic
- **Features**:
  - Smart categorization (obvious vs. valuable)
  - License and directive preservation
  - Interactive review process
  - Quality metrics reporting

#### `/review` - Code Quality Review
Comprehensive code review for security, bugs, and quality issues:
- **Security**: SQL injection, XSS, hardcoded secrets, crypto issues
- **Bugs**: Null handling, async/promise issues, type coercion
- **Quality**: Complexity analysis, code smells, error handling
- **Features**:
  - Severity classification (Critical → Low)
  - Auto-fix capabilities for safe issues
  - CVSS scoring for vulnerabilities
  - Trend analysis and continuous monitoring

#### `/test` - Smart Test Runner
Runs tests with intelligent failure analysis and fixing assistance:
- **Frameworks**: Jest, Pytest, Go test, Cargo test, Maven, Gradle
- **Features**:
  - Auto-discovery of test configuration
  - Failure pattern analysis
  - Root cause identification
  - Coverage reporting and debugging assistance

### Example Chores Workflow

```bash
# Clean up codebase before release
/format                    # Auto-format all code
/fix-imports              # Fix any broken imports
/cleanup-types            # Improve type safety
/remove-comments          # Clean up redundant comments
/review                   # Security and quality review
/test                     # Run comprehensive tests
/commit                   # Create meaningful commit
```

### Common Use Cases

**Pre-commit Cleanup:**
```bash
/format && /test && /commit
```

**Post-refactor Maintenance:**
```bash
/fix-imports && /cleanup-types && /review
```

**Release Preparation:**
```bash
/remove-comments && /format && /test && /review
```

These chores help maintain code quality, security, and consistency across your project with minimal manual effort.

## Settings Configuration

The `settings.json` file contains Claude Code configuration for hooks and tool permissions.

### Notification Hooks

The configuration includes a notification hook that sends alerts via [ntfy.sh](https://ntfy.sh):

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "curl -d \"Claude needs your attention\" ntfy.sh/$NTFY_TOPIC"
          }
        ]
      }
    ]
  }
}
```

**Setup:**
1. Set the `NTFY_TOPIC` environment variable to your ntfy.sh topic
2. The hook will send push notifications when Claude requires attention
3. Empty matcher means it applies to all situations

### Allowed Tools

The configuration permits Claude to use these tools:

- **Task** - Launch specialized sub-agents
- **Bash** ⚠️ - Execute system commands (use with caution)
- **Glob** - File pattern matching
- **Grep** - Code search functionality  
- **LS** - Directory listings
- **Read** - File reading
- **Edit** - Single file modifications
- **MultiEdit** - Multiple edits to single files
- **Write** - File creation/overwriting
- **WebFetch** - Web content retrieval
- **WebSearch** - Web search capabilities

### Security Note

The `Bash` tool is marked as dangerous because it allows execution of arbitrary system commands. **ONLY** enable this if you trust the AI assistant completely and understand the security implications.

### Customization

You can modify `settings.json` to:
- Add custom notification hooks
- Restrict or expand tool permissions
- Configure different hook matchers for specific scenarios
- Set up additional notification channels


## Contributing

Feel free to submit pull requests, bug reports, or feature requests!

## Claude Code too expensive?

> In addition to Qwen Code, you can now use Qwen3‑Coder with Claude Code. Simply request an API key on Alibaba Cloud Model Studio platform and install Claude Code to start coding.

Details about using [Qwen3-Coder with Claude](https://qwenlm.github.io/blog/qwen3-coder/#claude-code)

## License

Apache 2.0

## Credits

A **lot** of inspiration was taken from: 

- The PRD fodler was modified from Ryan Carsons [ai-dev-tasks](https://github.com/snarktank/ai-dev-tasks/) 
- The chores folder was modified from Brenner Cruvinel's [CCPlugins](https://github.com/brennercruvinel/CCPlugins)
- Claude Code Opus 4.1 did most of the heavy lifting
- [ClaudeLog](https://claudelog.com/) and the [Anthropic documentation](https://docs.anthropic.com/en/docs/claude-code/overview) is essential reading to getting the most 
