#!/bin/bash
# Test framework for Git-Go

# Colors for test output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="${3:-Test}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "$expected" == "$actual" ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Expected: $expected"
        echo -e "  Actual:   $actual"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="${3:-Test}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "$haystack" == *"$needle"* ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Expected to contain: $needle"
        echo -e "  Actual: $haystack"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_file_exists() {
    local file="$1"
    local test_name="${2:-File exists: $file}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  File not found: $file"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_command_success() {
    local command="$1"
    local test_name="${2:-Command succeeds: $command}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if eval "$command" &>/dev/null; then
        echo -e "${GREEN}✓${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Command failed: $command"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_command_fails() {
    local command="$1"
    local test_name="${2:-Command fails: $command}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if eval "$command" &>/dev/null; then
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Command succeeded but should have failed: $command"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        echo -e "${GREEN}✓${NC} $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi
}

# Test suite functions
describe() {
    echo
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}$(printf '=%.0s' {1..${#1}})${NC}"
}

test_summary() {
    echo
    echo -e "${BOLD}Test Summary${NC}"
    echo "────────────────"
    echo -e "Tests run:    $TESTS_RUN"
    echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
    echo
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}✓ All tests passed!${NC}"
        return 0
    else
        echo -e "${RED}✗ Some tests failed${NC}"
        return 1
    fi
}

# Setup and teardown
setup_test_env() {
    export TEST_DIR="$(mktemp -d -t git-go-test-XXXXXX)"
    export ORIGINAL_DIR="$(pwd)"
    export GIT_GO="${ORIGINAL_DIR}/bin/git-go"
    
    # Override config for testing
    export CONFIG_DIR="$TEST_DIR/.config/git-go"
    mkdir -p "$CONFIG_DIR"
    
    # Create test config
    cat > "$CONFIG_DIR/config" << EOF
# Test configuration
GIT_PRIMARY_HOST="test.example.com"
GIT_PRIMARY_USER="testuser"
GIT_PRIMARY_PREFIX="git@test.example.com:"
WORK_DIR="$TEST_DIR/src"
EOF
    
    cd "$TEST_DIR"
}

cleanup_test_env() {
    cd "$ORIGINAL_DIR"
    rm -rf "$TEST_DIR"
}