#!/usr/bin/env bash
# Installs the Ember delta config into ~/.config/delta/. It does not edit
# ~/.gitconfig: add the [include] it prints.
set -e
dir="$(cd "$(dirname "$0")" && pwd)"
dest=~/.config/delta
mkdir -p "$dest"
[ -f "$dest/ember.gitconfig" ] && cp "$dest/ember.gitconfig" "$dest/ember.gitconfig.bak"
cp "$dir/ember.gitconfig" "$dest/"
if [ -f ~/.gitconfig ] && grep -qF "delta/ember.gitconfig" ~/.gitconfig; then
    echo "Done. ~/.gitconfig already includes it."
else
    echo "Done. Add to ~/.gitconfig:"
    echo "  [include]"
    echo "      path = ~/.config/delta/ember.gitconfig"
fi
echo "Needs the bat Ember theme for the code colours: ./bat/install.sh"
