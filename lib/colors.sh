#!/bin/bash
# Color definitions and output functions

# Check if colors are enabled
if [[ "${USE_COLORS:-true}" == "true" ]] && [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    PURPLE='\033[0;35m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    PURPLE=''
    CYAN=''
    BOLD=''
    NC=''
fi

# Output functions
error() {
    echo -e "${RED}❌ $*${NC}" >&2
}

success() {
    echo -e "${GREEN}✅ $*${NC}"
}

info() {
    echo -e "${BLUE}ℹ️  $*${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $*${NC}"
}

highlight() {
    echo -e "${PURPLE}$*${NC}"
}

step() {
    echo -e "${CYAN}▶ $*${NC}"
}