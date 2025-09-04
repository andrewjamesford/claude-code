# CLAUDE.md

Please follow the Clean Code principles.

## Clean Code principles

Code is clean if it can be understood easily – by everyone on the team. Clean code can be read and enhanced by a developer other than its original author. With understandability comes readability, changeability, extensibility and maintainability.

### General rules

1. Follow standard conventions.
2. Keep it simple stupid. Simpler is always better. Reduce complexity as much as possible.
3. Boy scout rule. Leave the campground cleaner than you found it.
4. Always find root cause. Always look for the root cause of a problem.

### Design rules

1. Keep configurable data at high levels.
2. Prefer polymorphism to if/else or switch/case.
3. Separate multi-threading code.
4. Prevent over-configurability.
5. Use dependency injection.
6. Follow Law of Demeter. A class should know only its direct dependencies.
7. Use the rule of three to determine when to implement DRY (Don't Repeat Yourself)

### Understandability tips

1. Be consistent. If you do something a certain way, do all similar things in the same way.
2. Use explanatory variables.
3. Encapsulate boundary conditions. Boundary conditions are hard to keep track of. Put the processing for them in one place.
4. Prefer dedicated value objects to primitive type.
5. Avoid logical dependency. Don't write methods which works correctly depending on something else in the same class.
6. Avoid negative conditionals.

### Names rules

1. Choose descriptive and unambiguous names.
2. Make meaningful distinction.
3. Use pronounceable names.
4. Use searchable names.
5. Replace magic numbers with named constants.
6. Avoid encodings. Don't append prefixes or type information.

### Functions rules

1. Small.
2. Do one thing.
3. Use descriptive names.
4. Prefer fewer arguments.
5. Have no side effects.
6. Don't use flag arguments. Split method into several independent methods that can be called from the client without the flag.

### Comments rules

1. Always try to explain yourself in code.
2. Don't be redundant.
3. Don't add obvious noise.
4. Don't use closing brace comments.
5. Don't comment out code. Just remove.
6. Use as explanation of intent.
7. Use as clarification of code.
8. Use as warning of consequences.

### Source code structure

1. Separate concepts vertically.
2. Related code should appear vertically dense.
3. Declare variables close to their usage.
4. Dependent functions should be close.
5. Similar functions should be close.
6. Place functions in the downward direction.
7. Keep lines short.
8. Don't use horizontal alignment.
9. Use white space to associate related things and disassociate weakly related.
10. Don't break indentation.

### Objects and data structures

1. Hide internal structure.
2. Prefer data structures.
3. Avoid hybrids structures (half object and half data).
4. Should be small.
5. Do one thing.
6. Small number of instance variables.
7. Base class should know nothing about their derivatives.
8. Better to have many functions than to pass some code into a function to select a behavior.
9. Prefer non-static methods to static methods.

### Tests

1. One assert per test.
2. Readable.
3. Fast.
4. Independent.
5. Repeatable.

### Code smells

1. Rigidity. The software is difficult to change. A small change causes a cascade of subsequent changes.
2. Fragility. The software breaks in many places due to a single change.
3. Immobility. You cannot reuse parts of the code in other projects because of involved risks and high effort.
4. Needless Complexity.
5. Needless Repetition.
6. Opacity. The code is hard to understand.

## Tools

You have access to multiple CLI tools for example Chrome CLI to control chromium browsers, Playwright Test CLI for browser automation and end-to-end tests, Gemini CLI, Qwen CLI, GH CLI (for GitHub and GitHub Copilot), pgcli: Enhanced PostgreSQL CLI; psql: Standard PostgreSQL command-line clients for Postresql Server that can help you with different tasks, such as subagent requests.

- Gemini CLI Prompt example - `gemini -a -p "<YOUR PROMPT>"` - with the -a All files, and -p prompt flags
- Gemini CLI Help - `gemini -h` - to see all commands available
- GH CLI - `gh <command> <subcommand> [flags]` - to see all commands available to use `gh -h`
- GH CLI Copilot code explanation example - `gh copilot explain "<your command or code here>"` - Use copilot explain from the CLI
- GH CLI Copilot code suggestions - `gh copilot suggest "<your task here>"` - Use copilot suggest from the CLI
- Qwen CLI Prompt example - `qwen -p "<YOUR PROMPT>"` - and -p prompt flag
- Qwen CLI Help - `qwen -h` - to see all commands available
- PostgreSQL CLI Help - `psql --help` - to see all commands available
- pgcli Enhanced PostgreSQL CLI Help - `pgcli --help` - to see all commands available
- Chrome CLI Help - `chrome-cli --help` - to see all commands available
- Playwright CLI - `npx playwright test --help` - to see all commands available
- Docker CLI - `docker --help` - to see all commands available
- Docker CLI container logs example - `docker logs -f <container_name_or_id>` - View and follow container logs in real-time
- Docker CLI list containers - `docker ps -a` - List all containers (running and stopped)
- ast-grep cli find and replace code by syntax - `ast-grep --help` - to see all commands

## Specialized Agents

You also have access to specialized sub-agents for complex tasks:

- **playwright-test-expert**: Expert in writing, debugging, and maintaining Playwright end-to-end tests
- **tdd-testing-advocate**: Implements Test-Driven Development methodology and comprehensive test suites  
- **qa-test-engineer**: Runs tests, performs linting, and ensures code quality standards
- **code-review-specialist**: Provides expert code reviews for quality, security, and maintainability
- **software-architect**: Designs features, establishes architecture patterns, and makes technology decisions
- **tech-pm-prd-expert**: Creates Product Requirement Documents and breaks down complex features
- **gemini-context-expert**: Leverages Gemini's capabilities for comprehensive codebase analysis
- **qwen-context-expert**: Uses Qwen's advanced language capabilities for code understanding
- **docker-expert**: Expert in Docker containerization, debugging container issues, and analyzing container logs
- **ast-grep-expert**: Expert in structural code search, AST-based refactoring, and automated code transformations using ast-grep CLI
