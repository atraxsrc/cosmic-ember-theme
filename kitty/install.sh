#!/usr/bin/env bash
# Installs the Ember kitty colour scheme into ~/.config/kitty/themes/
set -e
dir="$(cd "$(dirname "$0")" && pwd)"
dest=~/.config/kitty/themes
mkdir -p "$dest"
[ -f "$dest/Ember.conf" ] && cp "$dest/Ember.conf" "$dest/Ember.conf.bak"
cp "$dir/Ember.conf" "$dest/"
echo "Done. Add to ~/.config/kitty/kitty.conf:  include themes/Ember.conf"
echo "then reload kitty (Ctrl+Shift+F5)."
