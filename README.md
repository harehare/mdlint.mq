# lint.mq

A Markdown linter implementing markdownlint rules in the `mq`.

## Overview

`lint.mq` is a linting tool that validates Markdown files against established style rules from [markdownlint](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md). It helps maintain consistent and high-quality Markdown documentation.

## Features

- **Rule-based Linting**: Implements markdownlint rules to ensure Markdown quality
- **Detailed Error Reports**: Provides clear, actionable feedback with line numbers and severity levels
- **Severity Levels**: Categorizes issues as errors, warnings, or info
- **Formatted Output**: Pretty-printed reports with icons and summaries

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

## Usage

The linter provides several functions:

### `lint_all(content)`
Runs all linting rules on the provided Markdown content and returns a result with issues and summary.

### `generate_report(lint_result)`
Generates a formatted report from the lint results, including:
- Issue count by severity (errors, warnings, info)
- Detailed list of all issues with line numbers
- Success message if no issues found

### Example Output

When issues are found:
```
# Markdown Lint Report

Found 2 issues:
- ❌ Errors: 2
- ⚠️  Warnings: 0
- ℹ️  Info: 0

## Issues
3:1 ❌ MD001 (heading-increment) - Heading level 3 skipped (expected level 2 or lower)
7:1 ❌ MD001 (heading-increment) - Heading level 4 skipped (expected level 3 or lower)
```

When no issues are found:
```
✅ No issues found! Your Markdown is looking great.
```

## File Structure

```
lint.mq/
├── lint.mq           # Main linter implementation
├── README.md         # This file
└── sample.md         # Sample Markdown file for testing
```

## Testing

Use the provided `sample.md` file to test the linter functionality.

## Future Enhancements

- Additional markdownlint rules (MD002-MD050+)
- Configuration file support
- Custom rule definitions
- Integration with CI/CD pipelines
- Multiple output formats (JSON, XML, etc.)

## References

- [markdownlint Rules Documentation](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md)
- [Markdown Guide](https://www.markdownguide.org/)

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
