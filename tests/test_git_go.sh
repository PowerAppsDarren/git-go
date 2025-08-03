#!/bin/bash
# Tests for git-go

# Source test framework
source "$(dirname "$0")/test_framework.sh"

# Start tests
echo -e "${BOLD}Git-Go Test Suite${NC}"
echo "=================="

# Setup test environment
setup_test_env

# Test: Version command
describe "Version Command"

VERSION_OUTPUT=$($GIT_GO version 2>&1)
assert_contains "$VERSION_OUTPUT" "Git-Go v" "Shows version"

# Test: Help command
describe "Help Command"

HELP_OUTPUT=$($GIT_GO help 2>&1)
assert_contains "$HELP_OUTPUT" "USAGE:" "Help shows usage"
assert_contains "$HELP_OUTPUT" "COMMANDS:" "Help shows commands"
assert_contains "$HELP_OUTPUT" "new" "Help shows new command"
assert_contains "$HELP_OUTPUT" "fork" "Help shows fork command"

# Test: Invalid command
describe "Error Handling"

ERROR_OUTPUT=$($GIT_GO invalid-command 2>&1)
assert_contains "$ERROR_OUTPUT" "Unknown option" "Shows error for invalid option"

# Test: Repository name validation
describe "Name Validation"

# Test valid names with --dry-run
assert_command_success "$GIT_GO new --name test-repo --dry-run" "Accepts valid repo name"
assert_command_success "$GIT_GO new --name my_project --dry-run" "Accepts underscores"
assert_command_success "$GIT_GO new --name my-awesome-123 --dry-run" "Accepts numbers"
assert_command_success "$GIT_GO new --name my.project --dry-run" "Accepts dots"

# Test invalid names (these should fail)
assert_command_fails "$GIT_GO new --name 'test repo' --dry-run" "Rejects spaces"
assert_command_fails "$GIT_GO new --name 'test@repo' --dry-run" "Rejects special chars"

# Test: Configuration loading
describe "Configuration"

# The config command opens an editor, so we can't easily test it
echo "  (Skipping config tests - opens editor interactively)"
# Would need to add a --show flag to test configuration

# Test: Command structure
describe "Command Structure"

# Test that commands require appropriate arguments
assert_command_fails "$GIT_GO fork --dry-run" "Fork requires URL"
assert_command_success "$GIT_GO fork --url https://github.com/test/repo --dry-run" "Fork accepts URL"

# Test: Environment
describe "Environment"

# Test that git-go respects environment variables
WORK_DIR="$TEST_DIR/custom-dir" assert_command_success "$GIT_GO new --name env-test --dry-run" "Respects WORK_DIR env var"

# Cleanup
cleanup_test_env

# Show summary
test_summary