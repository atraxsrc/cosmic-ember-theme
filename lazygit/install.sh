#!/usr/bin/env bash
# Installs the Ember lazygit colours beside your own config.yml
set -e
dir="$(cd "$(dirname "$0")" && pwd)"
dest=~/.config/lazygit
mkdir -p "$dest"
[ -f "$dest/ember.yml" ] && cp "$dest/ember.yml" "$dest/ember.yml.bak"
cp "$dir/ember.yml" "$dest/"
echo "Done. zsh/ember.zsh points LG_CONFIG_FILE at config.yml plus ember.yml; without it:"
echo "  export LG_CONFIG_FILE=\"\$HOME/.config/lazygit/config.yml,\$HOME/.config/lazygit/ember.yml\""
