#!/usr/bin/env bash

set -e

# lint.mq installation script

readonly LINT_MQ_REPO="harehare/lint.mq"
readonly LINT_MQ_INSTALL_DIR="$HOME/.lint.mq"
readonly MQ_MODULE_DIR="$HOME/.mq"
readonly MQ_BIN_DIR="$HOME/.mq/bin"

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

# Display the mq-lint logo
show_logo() {
    cat << 'EOF'

    ███╗   ███╗ ██████╗       ██╗     ██╗███╗   ██╗████████╗
    ████╗ ████║██╔═══██╗      ██║     ██║████╗  ██║╚══██╔══╝
    ██╔████╔██║██║   ██║█████╗██║     ██║██╔██╗ ██║   ██║
    ██║╚██╔╝██║██║▄▄ ██║╚════╝██║     ██║██║╚██╗██║   ██║
    ██║ ╚═╝ ██║╚██████╔╝      ███████╗██║██║ ╚████║   ██║
    ╚═╝     ╚═╝ ╚══▀▀═╝       ╚══════╝╚═╝╚═╝  ╚═══╝   ╚═╝

EOF
    echo -e "${BOLD}${CYAN}  A Markdown Linter for mq Language${NC}"
    echo -e "${BLUE}  Implementing 50 markdownlint rules${NC}"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Install mq if not installed
install_mq() {
    if command -v mq &> /dev/null; then
        log "mq is already installed: $(which mq)"
        return 0
    fi

    warn "mq is not installed. Installing mq..."

    # Install mq using official install script
    log "Running mq installation script from https://mqlang.org/install.sh"

    if ! curl -sSL https://mqlang.org/install.sh | bash; then
        error "Failed to install mq"
    fi

    if command -v mq &> /dev/null; then
        log "✓ mq installed successfully: $(which mq)"
    else
        error "mq installation failed. Please try manually: curl -sSL https://mqlang.org/install.sh | bash"
    fi
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
    local files=("lint.mq" "mq-lint")

    log "Downloading lint.mq files (version: $version)..."

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
    log "Installing lint.mq to mq module directory..."

    # Create mq module directory if it doesn't exist
    mkdir -p "$MQ_MODULE_DIR"

    # Copy lint.mq file
    if [[ -f "$LINT_MQ_INSTALL_DIR/lint.mq" ]]; then
        cp "$LINT_MQ_INSTALL_DIR/lint.mq" "$MQ_MODULE_DIR/lint.mq"
        log "✓ Installed lint.mq to $MQ_MODULE_DIR/lint.mq"
    else
        error "lint.mq file not found in $LINT_MQ_INSTALL_DIR"
    fi

    # Copy default config file
    if [[ -f "$LINT_MQ_INSTALL_DIR/.lintrc.toml" ]]; then
        cp "$LINT_MQ_INSTALL_DIR/.lintrc.toml" "$MQ_MODULE_DIR/.lintrc.toml"
        log "✓ Installed default config to $MQ_MODULE_DIR/.lintrc.toml"
    fi

    # Install mq-lint executable script
    if [[ -f "$LINT_MQ_INSTALL_DIR/mq-lint" ]]; then
        mkdir -p "$MQ_BIN_DIR"
        cp "$LINT_MQ_INSTALL_DIR/mq-lint" "$MQ_BIN_DIR/mq-lint"
        chmod +x "$MQ_BIN_DIR/mq-lint"
        log "✓ Installed mq-lint executable to $MQ_BIN_DIR/mq-lint"
    else
        warn "mq-lint executable script not found in $LINT_MQ_INSTALL_DIR"
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
    if [[ -f "$MQ_MODULE_DIR/lint.mq" ]] && [[ -f "$MQ_BIN_DIR/mq-lint" ]]; then
        log "✓ lint.mq installation verified"
        log "✓ mq-lint executable verified"
        log "Installation verification successful!"
        return 0
    else
        error "lint.mq installation verification failed"
    fi
}

# Show post-installation instructions
show_post_install() {
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${GREEN}✨ lint.mq installed successfully! ✨${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BOLD}${CYAN}📦 Installation Location:${NC}"
    echo -e "  ${GREEN}▶${NC} Module: ${BLUE}$MQ_MODULE_DIR/lint.mq${NC}"
    echo -e "  ${GREEN}▶${NC} Executable: ${BLUE}$MQ_BIN_DIR/mq-lint${NC}"
    echo ""

    # Check if MQ_BIN_DIR is in PATH
    if [[ ":$PATH:" != *":$MQ_BIN_DIR:"* ]]; then
        echo -e "${BOLD}${YELLOW}⚠ PATH Configuration Required:${NC}"
        echo -e "  Add ${BLUE}$MQ_BIN_DIR${NC} to your PATH to use the ${CYAN}mq-lint${NC} command."
        echo ""
        echo -e "  ${YELLOW}For bash:${NC}"
        echo -e "    ${CYAN}echo 'export PATH=\"\$HOME/.mq/bin:\$PATH\"' >> ~/.bashrc${NC}"
        echo -e "    ${CYAN}source ~/.bashrc${NC}"
        echo ""
        echo -e "  ${YELLOW}For zsh:${NC}"
        echo -e "    ${CYAN}echo 'export PATH=\"\$HOME/.mq/bin:\$PATH\"' >> ~/.zshrc${NC}"
        echo -e "    ${CYAN}source ~/.zshrc${NC}"
        echo ""
    else
        log "✓ $MQ_BIN_DIR is already in your PATH"
        echo ""
    fi

    echo -e "${BOLD}${CYAN}🚀 Getting Started:${NC}"
    echo ""
    echo -e "  ${YELLOW}1.${NC} Lint a Markdown file:"
    echo -e "     ${CYAN}mq-lint README.md${NC}"
    echo ""
    echo -e "  ${YELLOW}2.${NC} Lint all Markdown files in current directory:"
    echo -e "     ${CYAN}mq-lint${NC}"
    echo ""
    echo -e "  ${YELLOW}3.${NC} Lint with custom configuration:"
    echo -e "     ${CYAN}mq-lint -c .lintrc.toml *.md${NC}"
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

    # Install mq if not installed
    install_mq

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
            echo "lint.mq installation script"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --help, -h        Show this help message"
            echo "  --version, -v     Show version and exit"
            exit 0
            ;;
        --version|-v)
            echo "lint.mq installer v1.0.0"
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
