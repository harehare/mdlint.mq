# Sample Markdown Document

This is a sample Markdown file for testing the lint.mq linter.

### est

## Introduction

This document demonstrates various Markdown features and may intentionally include linting issues for testing purposes.

### Background

The lint.mq tool helps maintain consistent Markdown formatting across your documentation.

## Features

Here are some key features:

- Rule-based validation
- Clear error messages
- Severity levels
- Pretty-printed output

### Installation

Follow these steps to get started:

1. Clone the repository
2. Navigate to the project directory
3. Run the linter on your Markdown files

## Examples

### Code Blocks

Here's a code example:

```javascript
function hello() {
  console.log("Hello, world!");
}
```

### Tables

| Feature | Status | Priority |
| ------- | ------ | -------- |
| MD001   | ✅      | High     |
| MD002   | ⏳      | Medium   |
| MD003   | ⏳      | Medium   |

### Links

Check out the [markdownlint documentation](https://github.com/markdownlint/markdownlint) for more information.

## Test Cases

### Valid Heading Progression

This section follows proper heading hierarchy.

#### Subsection Level 4

Content here.

##### Subsection Level 5

More content.

### Intentional Linting Issues

The following section may trigger MD001 if uncommented:

<!-- Uncomment to test MD001:
# Main Heading
### Skipped Level (Should be H2)
-->

## Conclusion

This sample file demonstrates various Markdown features and can be used to test the lint.mq linter functionality.

### Next Steps

- Run the linter on this file
- Review the output
- Fix any reported issues
- Integrate into your workflow

## Additional Resources

- [Markdown Guide](https://www.markdownguide.org/)
- [CommonMark Spec](https://commonmark.org/)
- [GitHub Flavored Markdown](https://github.github.com/gfm/)

---

**Note**: This is a test file. Feel free to modify it to test different linting scenarios.
