#!/bin/bash
# Run all Git-Go tests

echo "🧪 Running Git-Go Test Suite"
echo "============================"

# Run main tests
./tests/test_git_go.sh

# Show TDD example (optional)
if [[ "$1" == "--tdd-example" ]]; then
    echo
    ./tests/tdd_example.sh
fi