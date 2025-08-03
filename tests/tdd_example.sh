#!/bin/bash
# Example of Test-Driven Development for Git-Go

source "$(dirname "$0")/test_framework.sh"

echo -e "${BOLD}TDD Example: Adding a 'git-go status' command${NC}"
echo "=============================================="
echo
echo "In TDD, we write tests FIRST, watch them fail, then implement the feature."
echo

describe "Step 1: Write failing tests for 'git-go status'"

# These tests will FAIL because the feature doesn't exist yet
STATUS_OUTPUT=$($GIT_GO status 2>&1 || true)

# Test what we WANT the feature to do
assert_contains "$STATUS_OUTPUT" "Repository Status" "Shows status header"
assert_contains "$STATUS_OUTPUT" "Local:" "Shows local repo info"
assert_contains "$STATUS_OUTPUT" "Remotes:" "Shows remote info"

echo
echo "Expected: All tests above should FAIL (red ✗)"
echo "This is good! We've defined what we want."
echo
echo -e "${YELLOW}Step 2: Implement the feature${NC}"
echo "Now we would add the 'status' command to git-go that:"
echo "  - Shows current repo status"
echo "  - Lists configured remotes"
echo "  - Shows sync status"
echo
echo -e "${YELLOW}Step 3: Run tests again${NC}"
echo "After implementation, run tests to see them pass (green ✓)"
echo
echo -e "${BLUE}Benefits of TDD:${NC}"
echo "  1. Tests define the feature before coding"
echo "  2. You know when you're done (tests pass)"
echo "  3. Prevents regression (tests catch breaks)"
echo "  4. Documents expected behavior"
echo "  5. Forces you to think about edge cases"

# Don't count these as real test failures
TESTS_RUN=0
TESTS_FAILED=0
TESTS_PASSED=0