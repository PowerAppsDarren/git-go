#!/bin/bash
#
# GoGo Global - Universal Project Deployment and Testing Script
# Works with any project type
#

# Don't exit on error - we want to run all steps
set +e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Get project directory and name
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"

# Timestamp for logs
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo -e "${BOLD}🚀 GoGo - Universal Project Pipeline${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "Project: ${YELLOW}$PROJECT_NAME${NC}"
echo -e "Path: $PROJECT_DIR"
echo -e "Started at: $TIMESTAMP\n"

# Step counter
STEP=0
step() {
    ((STEP++))
    echo -e "\n${BOLD}Step $STEP: $1${NC}"
    echo -e "${BLUE}$(printf '─%.0s' {1..50})${NC}"
}

# Success/failure tracking
FAILURES=0
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

error() {
    echo -e "${RED}✗ $1${NC}"
    ((FAILURES++))
}

info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Detect project type
detect_project_type() {
    local project_type="unknown"
    
    # Check for specific project files
    if [[ -f "package.json" ]]; then
        project_type="node"
    elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]] || [[ -f "pyproject.toml" ]]; then
        project_type="python"
    elif [[ -f "go.mod" ]]; then
        project_type="go"
    elif [[ -f "Cargo.toml" ]]; then
        project_type="rust"
    elif [[ -f "pom.xml" ]]; then
        project_type="java-maven"
    elif [[ -f "build.gradle" ]] || [[ -f "build.gradle.kts" ]]; then
        project_type="java-gradle"
    elif [[ -f "Gemfile" ]]; then
        project_type="ruby"
    elif [[ -f "composer.json" ]]; then
        project_type="php"
    elif [[ -f "Makefile" ]]; then
        project_type="make"
    elif [[ -d ".git" ]]; then
        project_type="generic-git"
    else
        project_type="generic"
    fi
    
    echo "$project_type"
}

# Run tests based on project type
run_tests() {
    local project_type=$1
    local test_passed=false
    
    echo "Detected project type: ${YELLOW}$project_type${NC}"
    
    case "$project_type" in
        node)
            if [[ -f "package.json" ]]; then
                # Check for test script
                if grep -q '"test"' package.json; then
                    info "Running npm test..."
                    if npm test; then
                        success "npm test passed"
                        test_passed=true
                    else
                        error "npm test failed"
                    fi
                else
                    info "No test script found in package.json"
                fi
                
                # Check for lint script
                if grep -q '"lint"' package.json; then
                    info "Running npm run lint..."
                    if npm run lint; then
                        success "Linting passed"
                    else
                        error "Linting failed"
                    fi
                fi
            fi
            ;;
            
        python)
            # Try pytest first
            if command -v pytest &> /dev/null; then
                info "Running pytest..."
                if pytest; then
                    success "pytest passed"
                    test_passed=true
                else
                    error "pytest failed"
                fi
            elif [[ -f "manage.py" ]]; then
                # Django project
                info "Running Django tests..."
                if python manage.py test; then
                    success "Django tests passed"
                    test_passed=true
                else
                    error "Django tests failed"
                fi
            elif [[ -d "tests" ]] || [[ -d "test" ]]; then
                info "Running Python unittest..."
                if python -m unittest discover; then
                    success "Python tests passed"
                    test_passed=true
                else
                    error "Python tests failed"
                fi
            fi
            ;;
            
        go)
            info "Running go test..."
            if go test ./...; then
                success "Go tests passed"
                test_passed=true
            else
                error "Go tests failed"
            fi
            ;;
            
        rust)
            info "Running cargo test..."
            if cargo test; then
                success "Rust tests passed"
                test_passed=true
            else
                error "Rust tests failed"
            fi
            ;;
            
        make)
            if grep -q "^test:" Makefile; then
                info "Running make test..."
                if make test; then
                    success "Make test passed"
                    test_passed=true
                else
                    error "Make test failed"
                fi
            fi
            ;;
            
        *)
            # Look for common test directories or scripts
            if [[ -f "./test.sh" ]]; then
                info "Running ./test.sh..."
                if ./test.sh; then
                    success "test.sh passed"
                    test_passed=true
                else
                    error "test.sh failed"
                fi
            elif [[ -f "./tests/test.sh" ]]; then
                info "Running ./tests/test.sh..."
                if ./tests/test.sh; then
                    success "tests/test.sh passed"
                    test_passed=true
                else
                    error "tests/test.sh failed"
                fi
            elif [[ -d "tests" ]] || [[ -d "test" ]]; then
                info "Found test directory but no standard test runner"
            else
                info "No standard test configuration found"
            fi
            ;;
    esac
    
    if [[ "$test_passed" == "false" ]]; then
        info "No tests were run or all tests were skipped"
    fi
}

# Update documentation files
update_documentation() {
    local updated=false
    
    # Update roadmap.md if it exists
    if [[ -f "roadmap.md" ]] || [[ -f "ROADMAP.md" ]]; then
        local roadmap_file="roadmap.md"
        [[ -f "ROADMAP.md" ]] && roadmap_file="ROADMAP.md"
        
        # Add timestamp to roadmap
        if ! grep -q "Last updated:" "$roadmap_file"; then
            echo -e "\n---\n*Last updated: $(date +"%Y-%m-%d %H:%M:%S")*" >> "$roadmap_file"
            success "Updated $roadmap_file with timestamp"
            updated=true
        fi
    fi
    
    # Update CHANGELOG.md if it exists
    if [[ -f "CHANGELOG.md" ]] || [[ -f "changelog.md" ]]; then
        local changelog_file="CHANGELOG.md"
        [[ -f "changelog.md" ]] && changelog_file="changelog.md"
        
        # Add entry for gogo run
        if ! grep -q "$(date +%Y-%m-%d).*GoGo deployment" "$changelog_file"; then
            # Create temp file with new entry
            {
                echo "## [Unreleased]"
                echo ""
                echo "### Maintenance"
                echo "- $(date +%Y-%m-%d): GoGo deployment pipeline executed"
                echo ""
                cat "$changelog_file"
            } > "$changelog_file.tmp"
            mv "$changelog_file.tmp" "$changelog_file"
            success "Updated $changelog_file"
            updated=true
        fi
    fi
    
    if [[ "$updated" == "false" ]]; then
        info "No documentation files to update"
    fi
}

# Run project-specific deployment
run_deployment() {
    local project_type=$1
    local deployed=false
    
    # Look for common deployment scripts
    if [[ -f "./deploy.sh" ]]; then
        info "Running ./deploy.sh..."
        if ./deploy.sh; then
            success "deploy.sh completed"
            deployed=true
        else
            error "deploy.sh failed"
        fi
    elif [[ -f "./scripts/deploy.sh" ]]; then
        info "Running ./scripts/deploy.sh..."
        if ./scripts/deploy.sh; then
            success "scripts/deploy.sh completed"
            deployed=true
        else
            error "scripts/deploy.sh failed"
        fi
    elif [[ -f "Makefile" ]] && grep -q "^deploy:" Makefile; then
        info "Running make deploy..."
        if make deploy; then
            success "make deploy completed"
            deployed=true
        else
            error "make deploy failed"
        fi
    elif [[ "$project_type" == "node" ]] && grep -q '"build"' package.json; then
        info "Running npm run build..."
        if npm run build; then
            success "Build completed"
            deployed=true
        else
            error "Build failed"
        fi
    fi
    
    if [[ "$deployed" == "false" ]]; then
        info "No deployment script found"
    fi
}

# Main execution
main() {
    # Detect project type
    PROJECT_TYPE=$(detect_project_type)
    
    # 1. Run tests
    step "Running Tests"
    run_tests "$PROJECT_TYPE"
    
    # 2. Run linting/formatting if available
    step "Code Quality Checks"
    case "$PROJECT_TYPE" in
        node)
            if grep -q '"format"' package.json 2>/dev/null; then
                npm run format && success "Formatting completed" || error "Formatting failed"
            fi
            ;;
        python)
            if command -v black &> /dev/null; then
                black . && success "Black formatting completed" || error "Black formatting failed"
            fi
            if command -v flake8 &> /dev/null; then
                flake8 . && success "Flake8 passed" || error "Flake8 failed"
            fi
            ;;
        go)
            go fmt ./... && success "Go formatting completed" || error "Go formatting failed"
            ;;
        rust)
            cargo fmt && success "Rust formatting completed" || error "Rust formatting failed"
            ;;
        *)
            info "No standard formatting tools detected"
            ;;
    esac
    
    # 3. Update documentation
    step "Updating Documentation"
    update_documentation
    
    # 4. Run deployment
    step "Running Deployment"
    run_deployment "$PROJECT_TYPE"
    
    # 5. Git status check
    step "Repository Status"
    if [[ -d ".git" ]]; then
        echo -e "${YELLOW}Git Status:${NC}"
        git status --short
        
        # Show recent commits
        echo -e "\n${YELLOW}Recent Commits:${NC}"
        git log --oneline -5
    else
        info "Not a git repository"
    fi
    
    # 6. Generate summary
    step "Summary Report"
    echo -e "\n${BOLD}GoGo Pipeline Summary${NC}"
    echo -e "${BLUE}=====================${NC}"
    echo -e "Project: $PROJECT_NAME"
    echo -e "Type: $PROJECT_TYPE"
    echo -e "Started: $TIMESTAMP"
    echo -e "Ended: $(date +"%Y-%m-%d %H:%M:%S")"
    echo -e "\nResults:"
    
    if [[ $FAILURES -eq 0 ]]; then
        echo -e "${GREEN}✅ All steps completed successfully!${NC}"
        exit 0
    else
        echo -e "${RED}❌ $FAILURES steps failed${NC}"
        echo -e "\nPlease review the output above and fix any issues."
        exit 1
    fi
}

# Run main function
main "$@"