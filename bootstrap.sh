#!/usr/bin/env bash
set -euo pipefail

# ============================================
#  Dotfiles Bootstrap Script
#  Repo: https://github.com/gameforce/dotfiles
# ============================================

DOTFILES_DIR="${HOME}/.dotfiles"
REPO_URL="https://github.com/gameforce/dotfiles.git"
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
      pipx \
      python3-yaml \
      keychain \
      locales \
      build-essential \
      ca-certificates
  elif command -v dnf >/dev/null 2>&1; then
    echo "→ Detected Fedora. Installing packages..."
    sudo dnf install -y zsh git curl wget vim pipx python3-yaml keychain
  elif command -v pacman >/dev/null 2>&1; then
    echo "→ Detected Arch. Installing packages..."
    sudo pacman -Sy --noconfirm zsh git curl wget vim python-pipx python-yaml keychain
  else
    echo "⚠ Unsupported package manager. Please install zsh, git, vim, pipx and keychain manually."
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
  echo "→ Updating submodules..."
  git submodule update --init --recursive || true
}

# ----------------------------------------
# 3. Install / Update Dotbot via pipx
# ----------------------------------------
install_dotbot() {
  echo "→ Installing / updating Dotbot with pipx..."
  pipx ensurepath
  pipx install --force dotbot
  export PATH="${HOME}/.local/bin:${PATH}"
}

# ----------------------------------------
# 4. Run Dotbot
# ----------------------------------------
run_dotbot() {
  echo "→ Running Dotbot..."
  export PATH="${HOME}/.local/bin:${PATH}"
  dotbot -d "${DOTFILES_DIR}" -c "${DOTFILES_DIR}/${CONFIG_FILE}" "$@"
}

# ----------------------------------------
# 5. Change default shell to zsh
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
install_dotbot
run_dotbot "$@"
set_zsh_as_default

echo ""
echo "✓ Bootstrap complete!"
echo "  Log out and log back in (or run 'exec zsh') to start using your new shell."
