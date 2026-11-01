#!/usr/bin/env bash
# Installs the Ember Helix theme into ~/.config/helix/themes/
set -e
dir="$(cd "$(dirname "$0")" && pwd)"
dest=~/.config/helix/themes
mkdir -p "$dest"
[ -f "$dest/ember.toml" ] && cp "$dest/ember.toml" "$dest/ember.toml.bak"
cp "$dir/ember.toml" "$dest/"
echo 'Done. Add to ~/.config/helix/config.toml:  theme = "ember"'
