# Contributing to Git-Go

First off, thank you for considering contributing to Git-Go! 🎉

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Your environment (OS, Bash version, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- A clear and descriptive title
- A detailed description of the proposed feature
- Why this enhancement would be useful
- Possible implementation approach

### Pull Requests

1. Fork the repo and create your branch from `main`
2. If you've added code, add tests
3. Ensure the test suite passes: `./tests/test.sh`
4. Make sure your code follows the existing style
5. Write a clear commit message

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/git-go.git
cd git-go

# Create a branch
git checkout -b my-feature

# Make your changes
# ...

# Run tests
./tests/test.sh

# Commit your changes
git commit -m "Add amazing feature"

# Push to your fork
git push origin my-feature
```

## Style Guidelines

### Shell Script Style

- Use 4 spaces for indentation (no tabs)
- Always quote variables: `"$var"` not `$var`
- Use `[[ ]]` for conditionals, not `[ ]`
- Functions should be lowercase with underscores
- Add comments for complex logic
- Use meaningful variable names

### Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Keep the first line under 50 characters
- Reference issues and pull requests after the first line

## Testing

All new features should include tests. Run the test suite with:

```bash
./tests/test.sh
```

## Questions?

Feel free to open an issue with your question or contact the maintainers.

Thank you for contributing! 🚀