#!/usr/bin/env bash
# Installs the Ember WezTerm colour module into ~/.config/wezterm/
set -e
dir="$(cd "$(dirname "$0")" && pwd)"
dest=~/.config/wezterm
mkdir -p "$dest"
[ -f "$dest/ember.lua" ] && cp "$dest/ember.lua" "$dest/ember.lua.bak"
cp "$dir/ember.lua" "$dest/"
echo 'Done. Add to ~/.config/wezterm/wezterm.lua:  config.colors = require("ember")'
