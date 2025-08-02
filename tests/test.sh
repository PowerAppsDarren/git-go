#!/bin/bash
#
# Git-Go Test Suite
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test directory
TEST_DIR=$(mktemp -d)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GIT_GO="$SCRIPT_DIR/bin/git-go"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Cleanup on exit
cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

# Test functions
pass() {
    ((TESTS_PASSED++))
    echo -e "${GREEN}✓${NC} $1"
}

fail() {
    ((TESTS_FAILED++))
    echo -e "${RED}✗${NC} $1"
    echo "  Error: $2"
}

run_test() {
    ((TESTS_RUN++))
    echo -e "\n${BLUE}Test:${NC} $1"
}

# Setup test environment
export WORK_DIR="$TEST_DIR"
export GIT_PRIMARY_PREFIX="git@github.com:"
export GIT_PRIMARY_USER="testuser"

# Tests
echo -e "${BLUE}Running Git-Go Tests${NC}\n"

# Test 1: Help command
run_test "Help command"
if $GIT_GO help &>/dev/null; then
    pass "Help command works"
else
    fail "Help command failed" "$?"
fi

# Test 2: Version command
run_test "Version command"
if $GIT_GO version | grep -q "Git-Go"; then
    pass "Version command works"
else
    fail "Version command failed" "No version string found"
fi

# Test 3: Create new repository
run_test "Create new repository"
if $GIT_GO new --name test-project &>/dev/null; then
    if [[ -d "$TEST_DIR/test-project/.git" ]]; then
        pass "Repository created successfully"
    else
        fail "Repository creation failed" "No .git directory found"
    fi
else
    fail "Repository creation failed" "$?"
fi

# Test 4: Check generated files
run_test "Check generated files"
if [[ -f "$TEST_DIR/test-project/README.md" ]] && \
   [[ -f "$TEST_DIR/test-project/LICENSE" ]] && \
   [[ -f "$TEST_DIR/test-project/.gitignore" ]] && \
   [[ -f "$TEST_DIR/test-project/scripts/sync.sh" ]]; then
    pass "All expected files generated"
else
    fail "Missing generated files" "Some files were not created"
fi

# Test 5: VS Code integration
run_test "VS Code integration"
if [[ -f "$TEST_DIR/test-project/.vscode/tasks.json" ]]; then
    pass "VS Code integration created"
else
    fail "VS Code integration failed" "tasks.json not found"
fi

# Test 6: CLAUDE.md creation
run_test "CLAUDE.md creation"
if [[ -f "$TEST_DIR/test-project/CLAUDE.md" ]]; then
    pass "CLAUDE.md created"
else
    fail "CLAUDE.md creation failed" "File not found"
fi

# Test 7: Repository name validation
run_test "Repository name validation"
if ! $GIT_GO new --name "invalid name!" &>/dev/null; then
    pass "Invalid names are rejected"
else
    fail "Name validation failed" "Invalid name was accepted"
fi

# Test 8: Duplicate repository check
run_test "Duplicate repository check"
if ! $GIT_GO new --name test-project &>/dev/null; then
    pass "Duplicate repositories prevented"
else
    fail "Duplicate check failed" "Duplicate was allowed"
fi

# Summary
echo -e "\n${BLUE}Test Summary${NC}"
echo "Tests run: $TESTS_RUN"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}All tests passed! 🎉${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed${NC}"
    exit 1
fi