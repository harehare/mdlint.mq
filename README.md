# lint.mq

A Markdown linter implementing markdownlint rules in the `mq` language.

## Overview

`lint.mq` is a linting tool that validates Markdown files against established style rules from [markdownlint](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md). It helps maintain consistent and high-quality Markdown documentation.

## Features

- **Rule-based Linting**: Implements markdownlint rules to ensure Markdown quality
- **Detailed Error Reports**: Provides clear, actionable feedback with line numbers and severity levels
- **Severity Levels**: Categorizes issues as errors, warnings, or info
- **Formatted Output**: Pretty-printed reports with icons and summaries
- **Comprehensive Test Suite**: Includes test cases for all implemented rules

## Currently Implemented Rules

### MD001 - Heading Increment

**Rule Name**: `heading-increment`
**Severity**: Error

Ensures that heading levels increment by one level at a time. For example, you shouldn't skip from H1 directly to H3.

**Example:**

```markdown
# Heading 1
### Heading 3  ❌ Error: Skips H2
```

**Correct:**

```markdown
# Heading 1
## Heading 2  ✅ Correct
```

### MD002 - First Header Should Be H1

**Rule Name**: `first-header-h1`
**Severity**: Error

The first heading in the document should be a top-level (H1) heading.

**Example:**

```markdown
## Introduction  ❌ Error: First header should be H1
```

**Correct:**

```markdown
# Introduction  ✅ Correct
```

### MD024 - No Duplicate Headers

**Rule Name**: `no-duplicate-header`
**Severity**: Warning

Multiple headers with the same content can be confusing and should be avoided.

**Example:**

```markdown
# Setup
## Installation
# Setup  ❌ Warning: Duplicate header
```

### MD025 - Single H1

**Rule Name**: `single-h1`
**Severity**: Error

Documents should have only one top-level (H1) heading.

**Example:**

```markdown
# Introduction
## Details
# Conclusion  ❌ Error: Multiple H1 headers
```

### MD026 - No Trailing Punctuation

**Rule Name**: `no-trailing-punctuation`
**Severity**: Warning

Headers should not end with punctuation marks (`.`, `,`, `:`, `;`, `!`, `?`).

**Example:**

```markdown
# Introduction.  ❌ Warning: Trailing punctuation
# What is this?  ❌ Warning: Trailing punctuation
```

**Correct:**

```markdown
# Introduction  ✅ Correct
# What is this  ✅ Correct
```

### MD033 - No Inline HTML

**Rule Name**: `no-inline-html`
**Severity**: Warning

Inline HTML should be avoided in Markdown documents.

**Example:**

```markdown
# Header

<div>Some content</div>  ❌ Warning: Inline HTML
```

### MD040 - Fenced Code Language

**Rule Name**: `fenced-code-language`
**Severity**: Warning

Fenced code blocks should have a language specified for proper syntax highlighting.

**Example:**

````markdown
```
code without language  ❌ Warning: No language specified
```
````

**Correct:**

````markdown
```javascript
console.log("Hello");  ✅ Correct
```
````

## Configuration

lint.mq supports configuration via a TOML file (`.lintrc.toml`) that allows you to customize linting behavior.

### Configuration File

Create a `.lintrc.toml` file in your project root:

```toml
[lint]
# Output format: "detailed" or "concise"
output-format = "detailed"

# Quiet mode: suppress informational messages
quiet = false

# Rules to enable (comment out to disable a rule)
rules = [
  "MD001",  # heading-increment
  "MD002",  # first-header-h1
  "MD024",  # no-duplicate-header
  "MD025",  # single-h1
  "MD026",  # no-trailing-punctuation
  "MD033",  # no-inline-html
  "MD040",  # fenced-code-language
]

# Rule-specific configuration
[lint.md002]
level = 1  # Expected level for first header

[lint.md024]
siblings-only = false  # Check all headers or only siblings

[lint.md025]
level = 1  # Top level header number

[lint.md026]
punctuation = ".,;:!?"  # Punctuation to flag in headers

[lint.md033]
allowed-elements = []  # HTML elements to allow (empty = none)

[lint.md040]
enabled = true  # Require language specification for code blocks
```

### Loading Configuration

```mq
include "lint"

# Load configuration from file
let config = load_config(".lintrc.toml")
| let merged = merge_config(config)

# Use configuration with linting
let content = to_markdown(read_file("document.md"))
| let result = lint_all_with_config(content, merged)
| generate_report(result)
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `output-format` | string | "detailed" | Output format for reports |
| `quiet` | boolean | false | Suppress informational messages |
| `rules` | array | all enabled | List of rules to enable |

### Rule-Specific Options

**MD002** - First header level
- `level` (integer, default: 1): Expected level for the first header

**MD024** - Duplicate headers
- `siblings-only` (boolean, default: false): Only check sibling headers

**MD025** - Multiple top-level headers
- `level` (integer, default: 1): Level considered as "top-level"

**MD026** - Trailing punctuation
- `punctuation` (string, default: ".,;:!?"): Characters to flag

**MD033** - Inline HTML
- `allowed-elements` (array, default: []): HTML tags to allow

**MD040** - Code block language
- `enabled` (boolean, default: true): Require language specification

## Usage

The linter provides several functions that can be used in your mq scripts:

### Core Functions

#### `lint_all(content)`
Runs all linting rules with default configuration on the provided Markdown content and returns a result with issues and summary.

```mq
let content = to_markdown("# Title\n\n### Skipped Level\n")
| let result = lint_all(content)
| result["summary"]  # {errors: 1, warnings: 0, info: 0, total: 1}
```

#### `lint_all_with_config(content, config)`
Runs all linting rules with a custom configuration on the provided Markdown content.

```mq
let config = load_config(".lintrc.toml") | merge_config()
| let content = to_markdown("# Title\n\n## Section\n")
| let result = lint_all_with_config(content, config)
| result["summary"]
```

#### `generate_report(lint_result)`
Generates a formatted report from the lint results, including:
- Issue count by severity (errors, warnings, info)
- Detailed list of all issues with line numbers
- Success message if no issues found

```mq
let content = to_markdown("# Title\n\n## Section\n")
| let result = lint_all(content)
| generate_report(result)
```

### Individual Rule Functions

Each rule can also be called individually:

- `md001(content)` - Check heading increment
- `md002(content)` - Check first header is H1
- `md024(content)` - Check for duplicate headers
- `md025(content)` - Check for multiple H1s
- `md026(content)` - Check for trailing punctuation
- `md033(content)` - Check for inline HTML
- `md040(content)` - Check code block language specification

### Helper Functions

- `format_issue(issue)` - Format a single issue for display
- `count_by_severity(issues)` - Count issues by severity level

### Example Output

When issues are found:
```
# Markdown Lint Report

Found 3 issues:
- ❌ Errors: 2
- ⚠️  Warnings: 1
- ℹ️  Info: 0

## Issues
2:1 ❌ MD002 (first-header-h1) - First header should be h1 (found h2)
3:1 ❌ MD001 (heading-increment) - Heading level 3 skipped (expected level 2 or lower)
5:1 ⚠️ MD026 (no-trailing-punctuation) - Trailing punctuation in header: '.'
```

When no issues are found:
```
✅ No issues found! Your Markdown is looking great.
```

## File Structure

```
lint.mq/
├── .lintrc.toml      # Configuration file
├── lint.mq           # Main linter implementation
├── lint_tests.mq     # Comprehensive test suite
├── README.md         # This file
└── sample.md         # Sample Markdown file for testing
```

## Testing

The project includes a comprehensive test suite in `lint_tests.mq` that covers all implemented rules.

### Running Tests

```bash
mq lint_tests.mq
```

### Test Coverage

The test suite includes:

- **Rule Tests**: Tests for all 7 implemented rules (MD001, MD002, MD024, MD025, MD026, MD033, MD040)
  - Valid cases (should pass without issues)
  - Invalid cases (should detect issues)
- **Helper Function Tests**: Tests for `format_issue` and `count_by_severity`
- **Integration Tests**: Tests for `lint_all` with clean and problematic documents
- **Report Generation Tests**: Tests for `generate_report` with and without issues
- **Configuration Tests**: Tests for configuration loading, rule enabling/disabling, and custom rule settings

Total: 26 test cases

### Manual Testing

You can also use the provided `sample.md` file to test the linter functionality manually:

```mq
include "lint"

let content = to_markdown(read_file("sample.md"))
| let result = lint_all(content)
| generate_report(result)
```

## Future Enhancements

- Additional markdownlint rules (MD003-MD050+)
- Custom rule definitions
- Integration with CI/CD pipelines
- Multiple output formats (JSON, XML, SARIF)
- Auto-fix capabilities for certain rules
- Watch mode for continuous linting
- Enhanced HTML element filtering in MD033
- Line-level accuracy improvements

## References

- [markdownlint Rules Documentation](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md)
- [Markdown Guide](https://www.markdownguide.org/)

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
