#!/usr/bin/env bash

set -e

# mdlint.mq installation script

readonly LINT_MQ_REPO="harehare/mdlint.mq"
readonly LINT_MQ_INSTALL_DIR="$HOME/.mdlint.mq"
readonly MQ_MODULE_DIR="$HOME/.mq/modules"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Utility functions
log() {
    echo -e "${GREEN}ℹ${NC}  $*" >&2
}

warn() {
    echo -e "${YELLOW}⚠${NC}  $*" >&2
}

error() {
    echo -e "${RED}✗${NC}  $*" >&2
    exit 1
}

# Display the mdlint.mq logo
show_logo() {
    cat << 'EOF'

    ██╗     ██╗███╗   ██╗████████╗   ███╗   ███╗ ██████╗
    ██║     ██║████╗  ██║╚══██╔══╝   ████╗ ████║██╔═══██╗
    ██║     ██║██╔██╗ ██║   ██║      ██╔████╔██║██║   ██║
    ██║     ██║██║╚██╗██║   ██║      ██║╚██╔╝██║██║▄▄ ██║
    ███████╗██║██║ ╚████║   ██║      ██║ ╚═╝ ██║╚██████╔╝
    ╚══════╝╚═╝╚═╝  ╚═══╝   ╚═╝      ╚═╝     ╚═╝ ╚══▀▀═╝

EOF
    echo -e "${BOLD}${CYAN}  A Markdown Linter for mq Language${NC}"
    echo -e "${BLUE}  Implementing 50 markdownlint rules${NC}"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Check if mq is installed
check_mq_installed() {
    if ! command -v mq &> /dev/null; then
        error "mq is not installed. Please install mq first from https://github.com/harehare/mq"
    fi
    log "Found mq: $(which mq)"
}

# Download files from GitHub
download_files() {
    local version="$1"
    local files=("mdlint.mq" ".lintrc.toml")

    log "Downloading mdlint.mq files (version: $version)..."

    # Create installation directory
    mkdir -p "$LINT_MQ_INSTALL_DIR"

    for file in "${files[@]}"; do
        local url="https://raw.githubusercontent.com/$LINT_MQ_REPO/$version/$file"
        log "Downloading $file..."

        if ! curl -L --fail --progress-bar "$url" -o "$LINT_MQ_INSTALL_DIR/$file"; then
            error "Failed to download $file from $url"
        fi
    done

    log "Files downloaded successfully to $LINT_MQ_INSTALL_DIR"
}

# Install to mq module directory
install_to_mq_modules() {
    log "Installing mdlint.mq to mq module directory..."

    # Create mq module directory if it doesn't exist
    mkdir -p "$MQ_MODULE_DIR"

    # Copy mdlint.mq file
    if [[ -f "$LINT_MQ_INSTALL_DIR/mdlint.mq" ]]; then
        cp "$LINT_MQ_INSTALL_DIR/mdlint.mq" "$MQ_MODULE_DIR/mdlint.mq"
        log "✓ Installed mdlint.mq to $MQ_MODULE_DIR/mdlint.mq"
    else
        error "mdlint.mq file not found in $LINT_MQ_INSTALL_DIR"
    fi

    # Copy default config file
    if [[ -f "$LINT_MQ_INSTALL_DIR/.lintrc.toml" ]]; then
        cp "$LINT_MQ_INSTALL_DIR/.lintrc.toml" "$MQ_MODULE_DIR/.lintrc.toml"
        log "✓ Installed default config to $MQ_MODULE_DIR/.lintrc.toml"
    fi
}

# Get the latest release version from GitHub
get_latest_version() {
    local version
    version=$(curl -s "https://api.github.com/repos/$LINT_MQ_REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [[ -z "$version" ]]; then
        warn "Failed to get the latest release version, using 'main' branch"
        echo "main"
    else
        echo "$version"
    fi
}

# Verify installation
verify_installation() {
    if [[ -f "$MQ_MODULE_DIR/mdlint.mq" ]]; then
        log "✓ mdlint.mq installation verified"
        log "Installation verification successful!"
        return 0
    else
        error "mdlint.mq installation verification failed"
    fi
}

# Show post-installation instructions
show_post_install() {
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${GREEN}✨ mdlint.mq installed successfully! ✨${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BOLD}${CYAN}🚀 Getting Started:${NC}"
    echo ""
    echo -e "  ${YELLOW}1.${NC} Create a .mq script file:"
    echo -e "     ${CYAN}cat > lint_example.mq << 'EOF'"
    echo -e "include \"lint\""
    echo -e ""
    echo -e "let content = to_markdown(read_file(\"README.md\"))"
    echo -e "| let result = lint_all(content)"
    echo -e "| generate_report(result)"
    echo -e "EOF${NC}"
    echo ""
    echo -e "  ${YELLOW}2.${NC} Run the linter:"
    echo -e "     ${CYAN}mq -L $MQ_MODULE_DIR lint_example.mq${NC}"
    echo ""
    echo -e "  ${YELLOW}3.${NC} Or use it directly:"
    echo -e "     ${CYAN}mq -L $MQ_MODULE_DIR 'include \"lint\" | to_markdown(read_file(\"README.md\")) | lint_all(.) | generate_report(.)'${NC}"
    echo ""
    echo -e "${BOLD}${CYAN}⚡ Configuration:${NC}"
    echo -e "  ${GREEN}▶${NC} Default config: ${BLUE}$MQ_MODULE_DIR/.lintrc.toml${NC}"
    echo -e "  ${GREEN}▶${NC} Copy to your project: ${CYAN}cp $MQ_MODULE_DIR/.lintrc.toml .lintrc.toml${NC}"
    echo ""
    echo -e "${BOLD}${CYAN}📚 Learn More:${NC}"
    echo -e "  ${GREEN}▶${NC} Repository: ${BLUE}https://github.com/$LINT_MQ_REPO${NC}"
    echo -e "  ${GREEN}▶${NC} Documentation: ${BLUE}https://github.com/$LINT_MQ_REPO#readme${NC}"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Main installation function
main() {
    show_logo

    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        error "curl is required but not installed"
    fi

    # Check if mq is installed
    check_mq_installed

    # Get latest version
    local version
    version=$(get_latest_version)
    log "Using version: $version"

    # Download files
    download_files "$version"

    # Install to mq module directory
    install_to_mq_modules

    # Verify installation
    verify_installation

    # Show post-installation instructions
    show_post_install
}

# Handle script arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            echo "mdlint.mq installation script"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --help, -h        Show this help message"
            echo "  --version, -v     Show version and exit"
            exit 0
            ;;
        --version|-v)
            echo "mdlint.mq installer v1.0.0"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
    shift
done

# Check if we're running in a supported environment
if [[ -z "${BASH_VERSION:-}" ]]; then
    error "This installer requires bash"
fi

# Run the main installation
main "$@"
