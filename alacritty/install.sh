#!/usr/bin/env bash
# Installs the Ember Alacritty colour scheme into ~/.config/alacritty/themes/
set -e
dir="$(cd "$(dirname "$0")" && pwd)"
dest=~/.config/alacritty/themes
mkdir -p "$dest"
[ -f "$dest/ember.toml" ] && cp "$dest/ember.toml" "$dest/ember.toml.bak"
cp "$dir/ember.toml" "$dest/"
echo "Done. Add to ~/.config/alacritty/alacritty.toml:"
echo '  [general]'
echo '  import = ["~/.config/alacritty/themes/ember.toml"]'
