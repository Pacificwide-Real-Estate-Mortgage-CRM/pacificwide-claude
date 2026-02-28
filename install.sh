#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# pacificwide-claude installer
# Usage: curl -fsSL https://raw.githubusercontent.com/Pacificwide-Real-Estate-Mortgage-CRM/pacificwide-claude/main/install.sh | bash
# ─────────────────────────────────────────────────────────────────────────────

REPO="https://github.com/Pacificwide-Real-Estate-Mortgage-CRM/pacificwide-claude.git"
INSTALL_DIR="${HOME}/.pacificwide-claude"
BIN_NAME="pacificwide-claude"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
error()   { echo -e "${RED}✗${NC} $*" >&2; }

# Check prerequisites
if ! command -v git &>/dev/null; then
  error "git is required. Install it first."
  exit 1
fi

# Clone or update
if [[ -d "$INSTALL_DIR" ]]; then
  info "Updating existing installation..."
  git -C "$INSTALL_DIR" pull --ff-only
else
  info "Cloning pacificwide-claude..."
  git clone "$REPO" "$INSTALL_DIR"
fi

# Make CLI executable
chmod +x "${INSTALL_DIR}/bin/${BIN_NAME}"
success "CLI installed at ${INSTALL_DIR}/bin/${BIN_NAME}"

# Add to PATH
add_to_path() {
  local shell_rc="$1"
  local export_line="export PATH=\"\${HOME}/.pacificwide-claude/bin:\${PATH}\""

  if [[ -f "$shell_rc" ]] && grep -qF ".pacificwide-claude/bin" "$shell_rc" 2>/dev/null; then
    return 0 # Already in PATH
  fi

  echo "" >> "$shell_rc"
  echo "# pacificwide-claude CLI" >> "$shell_rc"
  echo "$export_line" >> "$shell_rc"
  return 1 # Added
}

path_added=false
if [[ -n "${ZSH_VERSION:-}" ]] || [[ "$SHELL" == *"zsh"* ]]; then
  if add_to_path "${HOME}/.zshrc"; then
    info "PATH already configured in ~/.zshrc"
  else
    success "Added to PATH in ~/.zshrc"
    path_added=true
  fi
elif [[ -n "${BASH_VERSION:-}" ]] || [[ "$SHELL" == *"bash"* ]]; then
  if add_to_path "${HOME}/.bashrc"; then
    info "PATH already configured in ~/.bashrc"
  else
    success "Added to PATH in ~/.bashrc"
    path_added=true
  fi
else
  # Try both
  add_to_path "${HOME}/.zshrc" 2>/dev/null || true
  add_to_path "${HOME}/.bashrc" 2>/dev/null || true
  path_added=true
fi

echo ""
echo -e "${GREEN}${BOLD}pacificwide-claude installed successfully!${NC}"
echo ""
echo -e "  ${BOLD}Quick start:${NC}"
echo "  cd your-project"
echo "  pacificwide-claude init"
echo ""

if [[ "$path_added" == true ]]; then
  echo -e "  ${BLUE}Restart your terminal or run:${NC}"
  echo "  source ~/.zshrc  # or ~/.bashrc"
  echo ""
fi
