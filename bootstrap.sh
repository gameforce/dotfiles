#!/usr/bin/env bash
set -euo pipefail

# ============================================
#  Dotfiles Bootstrap Script
#  Repo: https://github.com/gameforce/dotfiles
# ============================================

DOTFILES_DIR="${HOME}/.dotfiles"
REPO_URL="git@github.com:gameforce/dotfiles.git"
DOTBOT_DIR="anishathalye/dotbot"
DOTBOT_BIN="${DOTBOT_DIR}/bin/dotbot"
CONFIG_FILE="install.conf.yaml"

echo "→ Starting dotfiles bootstrap..."

# ----------------------------------------
# 1. Install required packages
# ----------------------------------------
install_packages() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "→ Detected Debian/Ubuntu. Installing packages..."
    sudo apt-get update
    sudo apt-get install -y \
      zsh \
      git \
      curl \
      wget \
      vim \
      locales \
      build-essential \
      ca-certificates
  elif command -v dnf >/dev/null 2>&1; then
    echo "→ Detected Fedora. Installing packages..."
    sudo dnf install -y zsh git curl wget vim
  elif command -v pacman >/dev/null 2>&1; then
    echo "→ Detected Arch. Installing packages..."
    sudo pacman -Sy --noconfirm zsh git curl wget vim
  else
    echo "⚠ Unsupported package manager. Please install zsh, git and vim manually."
  fi
}

# ----------------------------------------
# 2. Clone or update the repository
# ----------------------------------------
setup_repo() {
  if [ -d "${DOTFILES_DIR}/.git" ]; then
    echo "→ Dotfiles already cloned. Pulling latest changes..."
    git -C "${DOTFILES_DIR}" pull --rebase --autostash || true
  else
    echo "→ Cloning dotfiles repository..."
    git clone --recursive "${REPO_URL}" "${DOTFILES_DIR}"
  fi

  cd "${DOTFILES_DIR}"

  # Make sure submodules are initialized
  echo "→ Updating submodules..."
  git submodule update --init --recursive
}

# ----------------------------------------
# 3. Run Dotbot
# ----------------------------------------
run_dotbot() {
  echo "→ Running Dotbot..."
  "${DOTFILES_DIR}/${DOTBOT_BIN}" -d "${DOTFILES_DIR}" -c "${CONFIG_FILE}" "${@}"
}

# ----------------------------------------
# 4. Change default shell to zsh
# ----------------------------------------
set_zsh_as_default() {
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "→ Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    echo "✓ Default shell changed to zsh. Please log out and back in."
  else
    echo "→ zsh is already the default shell."
  fi
}

# ----------------------------------------
# Main
# ----------------------------------------
install_packages
setup_repo
run_dotbot "$@"
set_zsh_as_default

echo ""
echo "✓ Bootstrap complete!"
echo "  Log out and log back in (or run 'exec zsh') to start using your new shell."
