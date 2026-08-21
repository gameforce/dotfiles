#!/usr/bin/env bash
# Downloads and installs a Nerd Font (Mono variant) for the current user.
#
# Nothing font-related is vendored in this repo -- this always pulls
# whatever is currently the latest release from ryanoasis/nerd-fonts,
# so there's no multi-hundred-MB of font binaries sitting in git history.
#
# Usage: install-nerd-font.sh [FontName]
#   FontName defaults to "Hack" and must match a release asset name from
#   https://github.com/ryanoasis/nerd-fonts/releases/latest (e.g. Hack,
#   Meslo, FiraCode, JetBrainsMono, ...).
set -euo pipefail

FONT_NAME="${1:-Hack}"
RELEASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"

if [ "$(uname)" = "Darwin" ]; then
  FONT_DIR="$HOME/Library/Fonts"
else
  FONT_DIR="$HOME/.local/share/fonts"
fi
mkdir -p "$FONT_DIR"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "-> Downloading ${FONT_NAME} Nerd Font from ${RELEASE_URL}..."
curl -fsSL -o "${TMP_DIR}/${FONT_NAME}.zip" "$RELEASE_URL"

echo "-> Extracting the Mono variant (recommended for terminals)..."
unzip -oq "${TMP_DIR}/${FONT_NAME}.zip" "*NerdFontMono*.ttf" -d "$TMP_DIR"

cp "${TMP_DIR}"/*NerdFontMono*.ttf "${FONT_DIR}/"

if command -v fc-cache >/dev/null 2>&1; then
  echo "-> Refreshing font cache..."
  fc-cache -f "$FONT_DIR" >/dev/null
fi

echo "OK: ${FONT_NAME} Nerd Font Mono installed to ${FONT_DIR}"
echo "   Set your terminal's font to \"${FONT_NAME} Nerd Font Mono\"."
