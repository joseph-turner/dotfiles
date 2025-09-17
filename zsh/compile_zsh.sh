#!/usr/bin/env bash
set -euo pipefail
# Compile commonly sourced zsh files into .zwc for faster startup
# Run this manually after updating your dotfiles.

ZSH_DIR="$(dirname "$HOME/.zshrc")"
FILES=(
  "$ZSH_DIR/functions.zsh"
  "$ZSH_DIR/aliases.zsh"
  "$ZSH_DIR/keybindings.zsh"
  "$ZSH_DIR/plugins.zsh"
)

for f in "${FILES[@]}"; do
  if [[ -f "$f" ]]; then
    echo "Compiling $f"
    zsh -c "zcompile -u '$f'"
  fi
done

echo "Done. \nTo use compiled files, zsh will prefer .zwc files automatically if available."
