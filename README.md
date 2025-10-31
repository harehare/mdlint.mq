<h1 align="center">mdlint.mq</h1>

<p align="center">A Markdown linter implementing 50 markdownlint rules in the <code>mq</code> language.</p>

## Quick Start

```mq
include "lint"

# Lint a Markdown file
let content = to_markdown(read_file("document.md"))
| let result = lint_all(content)
| generate_report(result)
```

## Overview

`mdlint.mq` is a linting tool that validates Markdown files against established style rules from [markdownlint](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md). It helps maintain consistent and high-quality Markdown documentation.

## Features

- **50 Linting Rules**: Comprehensive implementation of markdownlint rules covering headings, lists, code blocks, links, tables, and more
- **Detailed Error Reports**: Provides clear, actionable feedback with line numbers and severity levels
- **Configurable**: Fully customizable via TOML configuration files
- **Severity Levels**: Categorizes issues as errors, warnings, or info
- **Formatted Output**: Pretty-printed reports with icons and summaries
- **Comprehensive Test Suite**: Extensive test coverage for all implemented rules

## Currently Implemented Rules

This linter implements **50 markdownlint rules** organized into the following categories:

### 📑 Headings (13 rules)

| Rule  | Name                             | Description                                               |
| ----- | -------------------------------- | --------------------------------------------------------- |
| MD001 | heading-increment                | Heading levels should increment by one level at a time    |
| MD002 | first-header-h1                  | First heading should be a top-level heading               |
| MD003 | heading-style                    | Heading style should be consistent                        |
| MD018 | no-missing-space-atx             | No space after hash on atx style heading                  |
| MD019 | no-multiple-space-atx            | Multiple spaces after hash on atx style heading           |
| MD020 | no-missing-space-closed-atx      | No space inside hashes on closed atx style heading        |
| MD021 | no-multiple-space-closed-atx     | Multiple spaces inside hashes on closed atx style heading |
| MD022 | blanks-around-headings           | Headings should be surrounded by blank lines              |
| MD023 | heading-start-left               | Headings must start at the beginning of the line          |
| MD024 | no-duplicate-heading             | Multiple headings with the same content                   |
| MD025 | single-title/single-h1           | Multiple top-level headings in the same document          |
| MD026 | no-trailing-punctuation          | Trailing punctuation in heading                           |
| MD041 | first-line-heading/first-line-h1 | First line in file should be a top-level heading          |

### 📋 Lists (8 rules)

| Rule  | Name                 | Description                                                   |
| ----- | -------------------- | ------------------------------------------------------------- |
| MD004 | ul-style             | Unordered list style should be consistent                     |
| MD005 | list-indent          | Inconsistent indentation for list items at the same level     |
| MD006 | ul-start-left        | Consider starting bulleted lists at the beginning of the line |
| MD007 | ul-indent            | Unordered list indentation                                    |
| MD029 | ol-prefix            | Ordered list item prefix                                      |
| MD030 | list-marker-space    | Spaces after list markers                                     |
| MD031 | blanks-around-fences | Fenced code blocks should be surrounded by blank lines        |
| MD032 | blanks-around-lists  | Lists should be surrounded by blank lines                     |

### 🔤 Whitespace & Formatting (6 rules)

| Rule  | Name                         | Description                                      |
| ----- | ---------------------------- | ------------------------------------------------ |
| MD009 | no-trailing-spaces           | Trailing spaces                                  |
| MD010 | no-hard-tabs                 | Hard tabs                                        |
| MD012 | no-multiple-blanks           | Multiple consecutive blank lines                 |
| MD013 | line-length                  | Line length                                      |
| MD027 | no-multiple-space-blockquote | Multiple spaces after blockquote symbol          |
| MD047 | single-trailing-newline      | Files should end with a single newline character |

### 💻 Code Blocks (4 rules)

| Rule  | Name                 | Description                                              |
| ----- | -------------------- | -------------------------------------------------------- |
| MD014 | commands-show-output | Dollar signs used before commands without showing output |
| MD040 | fenced-code-language | Fenced code blocks should have a language specified      |
| MD046 | code-block-style     | Code block style should be consistent                    |
| MD048 | code-fence-style     | Code fence style should be consistent                    |

### 🔗 Links & Images (7 rules)

| Rule  | Name                             | Description                                                   |
| ----- | -------------------------------- | ------------------------------------------------------------- |
| MD011 | no-reversed-links                | Reversed link syntax                                          |
| MD034 | no-bare-urls                     | Bare URL used                                                 |
| MD039 | no-space-in-links                | Spaces inside link text                                       |
| MD051 | link-fragments                   | Link fragments should be valid                                |
| MD052 | reference-links-images           | Reference links and images should use a label that is defined |
| MD053 | link-image-reference-definitions | Link and image reference definitions should be needed         |
| MD054 | link-image-style                 | Link and image style should be consistent                     |
| MD059 | link-text                        | Link text should be descriptive                               |

### ✨ Inline Elements (3 rules)

| Rule  | Name                 | Description                      |
| ----- | -------------------- | -------------------------------- |
| MD033 | no-inline-html       | Inline HTML                      |
| MD037 | no-space-in-emphasis | Spaces inside emphasis markers   |
| MD038 | no-space-in-code     | Spaces inside code span elements |

### 🎨 Style & Emphasis (3 rules)

| Rule  | Name                   | Description                                |
| ----- | ---------------------- | ------------------------------------------ |
| MD035 | hr-style               | Horizontal rule style should be consistent |
| MD036 | no-emphasis-as-heading | Emphasis used instead of a heading         |
| MD049 | emphasis-style         | Emphasis style should be consistent        |
| MD050 | strong-style           | Strong style should be consistent          |

### 💬 Blockquotes (2 rules)

| Rule  | Name                         | Description                             |
| ----- | ---------------------------- | --------------------------------------- |
| MD027 | no-multiple-space-blockquote | Multiple spaces after blockquote symbol |
| MD028 | no-blanks-blockquote         | Blank line inside blockquote            |

### 📊 Tables (4 rules)

| Rule  | Name                 | Description                                |
| ----- | -------------------- | ------------------------------------------ |
| MD055 | table-pipe-style     | Table pipe style should be consistent      |
| MD056 | table-column-count   | Table column count should be consistent    |
| MD058 | blanks-around-tables | Tables should be surrounded by blank lines |
| MD060 | table-column-style   | Table column alignment style               |

## Configuration

mdlint.mq supports configuration via a TOML file (`.lintrc.toml`) that allows you to customize linting behavior.

### Configuration File

Create a `.lintrc.toml` file in your project root:

```toml
[lint]
# Output format: "detailed" or "concise"
output-format = "detailed"

# Quiet mode: suppress informational messages
quiet = false

# Rules to enable (all 50 rules are enabled by default)
rules = [
  "MD001", "MD002", "MD003", "MD004", "MD005", "MD006", "MD007",
  "MD009", "MD010", "MD011", "MD012", "MD013", "MD014",
  "MD018", "MD019", "MD020", "MD021", "MD022", "MD023", "MD024", "MD025", "MD026",
  "MD027", "MD028", "MD029", "MD030", "MD031", "MD032", "MD033", "MD034", "MD035",
  "MD036", "MD037", "MD038", "MD039", "MD040", "MD041",
  "MD046", "MD047", "MD048", "MD049", "MD050",
  "MD051", "MD052", "MD053", "MD054", "MD055", "MD056",
  "MD058", "MD059", "MD060"
]

# Rule-specific configuration examples
[lint.md002]
level = 1  # Expected level for first header

[lint.md003]
style = "consistent"  # "consistent", "atx", "atx_closed", "setext", "setext_with_atx", "setext_with_atx_closed"

[lint.md004]
style = "consistent"  # "consistent", "asterisk", "plus", "dash"

[lint.md007]
indent = 2  # Spaces for unordered list indentation

[lint.md009]
br_spaces = 2  # Number of spaces for line break
strict = false  # Strict mode for trailing spaces

[lint.md010]
code_blocks = true  # Check hard tabs in code blocks

[lint.md012]
maximum = 1  # Maximum consecutive blank lines

[lint.md013]
line_length = 80  # Maximum line length
code_blocks = true  # Check line length in code blocks
tables = true  # Check line length in tables
headings = true  # Check line length in headings

[lint.md022]
lines_above = 1  # Blank lines above headings
lines_below = 1  # Blank lines below headings

[lint.md024]
siblings-only = false  # Check only sibling headings

[lint.md025]
level = 1  # Top level heading number

[lint.md026]
punctuation = ".,;:!?"  # Punctuation to flag in headings

[lint.md029]
style = "one_or_ordered"  # "one", "ordered", "one_or_ordered"

[lint.md030]
ul_single = 1  # Spaces after unordered list marker for single-line items
ol_single = 1  # Spaces after ordered list marker for single-line items
ul_multi = 1   # Spaces after unordered list marker for multi-line items
ol_multi = 1   # Spaces after ordered list marker for multi-line items

[lint.md033]
allowed-elements = []  # HTML elements to allow

[lint.md035]
style = "consistent"  # "consistent" or specific style

[lint.md036]
punctuation = ".,;:!?。，；：！？"  # Punctuation for emphasis check

[lint.md046]
style = "consistent"  # "consistent", "fenced", "indented"

[lint.md048]
style = "consistent"  # "consistent", "backtick", "tilde"

[lint.md049]
style = "consistent"  # "consistent", "asterisk", "underscore"

[lint.md050]
style = "consistent"  # "consistent", "asterisk", "underscore"

[lint.md054]
style = "consistent"  # "consistent", "inline", "full", "collapsed", "shortcut"

[lint.md055]
style = "consistent"  # "consistent", "leading_and_trailing", "leading_only", "trailing_only", "no_leading_or_trailing"

[lint.md056]
enabled = true  # Check table column count consistency

[lint.md058]
enabled = true  # Tables should be surrounded by blank lines

[lint.md059]
enabled = true  # Check link text descriptiveness

[lint.md060]
style = "consistent"  # "consistent", "left", "right", "center", "none"
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

| Option          | Type    | Default      | Description                                         |
| --------------- | ------- | ------------ | --------------------------------------------------- |
| `output-format` | string  | "detailed"   | Output format for reports ("detailed" or "concise") |
| `quiet`         | boolean | false        | Suppress informational messages                     |
| `rules`         | array   | all 50 rules | List of rules to enable                             |

> **Note**: Each rule can be configured individually. See the configuration file example above for all available rule-specific options.

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

Each of the 50 rules can be called individually. All rule functions follow the signature:

```mq
md###(markdown_content, lines, config) -> array of issues
```

**Available rules:**
- MD001, MD002, MD003, MD004, MD005, MD006, MD007, MD009, MD010, MD011, MD012, MD013, MD014
- MD018, MD019, MD020, MD021, MD022, MD023, MD024, MD025, MD026, MD027, MD028, MD029, MD030
- MD031, MD032, MD033, MD034, MD035, MD036, MD037, MD038, MD039, MD040, MD041
- MD046, MD047, MD048, MD049, MD050, MD051, MD052, MD053, MD054, MD055, MD056
- MD058, MD059, MD060

**Example:**
```mq
let content = to_markdown("# Title\n\n### Skipped Level\n")
| let lines = split("# Title\n\n### Skipped Level\n", "\n")
| let config = default_config()
| let issues = md001(content, lines, config)  # Check heading increment
```

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
mdlint.mq/
├── .lintrc.toml      # Configuration file
├── mdlint.mq           # Main linter implementation
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

- **Rule Tests**: Comprehensive tests for all 50 implemented rules
  - Valid cases (should pass without issues)
  - Invalid cases (should detect issues)
  - Edge cases and configuration options
- **Helper Function Tests**: Tests for utility functions like `format_issue` and `count_by_severity`
- **Integration Tests**: Tests for `lint_all` with clean and problematic documents
- **Report Generation Tests**: Tests for `generate_report` with various scenarios
- **Configuration Tests**: Tests for configuration loading, rule enabling/disabling, and custom rule settings

The test suite ensures comprehensive coverage of all linting rules and their configurations.

### Manual Testing

You can also use the provided `sample.md` file to test the linter functionality manually:

```mq
include "lint"

let content = to_markdown(read_file("sample.md"))
| let result = lint_all(content)
| generate_report(result)
```

## Future Enhancements

- ✅ ~~Additional markdownlint rules~~ (50 rules implemented!)
- Custom rule definitions
- Integration with CI/CD pipelines
- Multiple output formats (JSON, XML, SARIF)
- Auto-fix capabilities for certain rules
- Watch mode for continuous linting
- Performance optimizations for large files
- Plugin system for custom rules

## References

- [markdownlint Rules Documentation](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md)
- [Markdown Guide](https://www.markdownguide.org/)

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
