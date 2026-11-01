#!/usr/bin/env bash
# Installs the Ember Ghostty theme into ~/.config/ghostty/themes/
set -e
dir="$(cd "$(dirname "$0")" && pwd)"
dest=~/.config/ghostty/themes
mkdir -p "$dest"
[ -f "$dest/Ember" ] && cp "$dest/Ember" "$dest/Ember.bak"
cp "$dir/Ember" "$dest/"
echo "Done. Add to ~/.config/ghostty/config:  theme = Ember"
echo "(or  theme = dark:Ember,light:EmberDay  to follow COSMIC's toggle), then reload: Ctrl+Shift+,"
