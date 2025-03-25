#!/usr/bin/env bash

# A rebuild script that hopefully works
# Inspired(C-V) by noboilerplate on youtube
set -e

# cd to your config
pushd ~/nixos-config/

# Early return if no changes
if git diff --quiet '*.nix'; then
	echo "No changes detected, exiting."
	popd
	exit 0
fi

# Collect any nixos garbage left over from nix-shell
nix-collect-garbage -d

# Formating all nix files in this directory using alejandra
alejandra . >/dev/null \
	|| ( alejandra . ; echo "formatting failed" && exit 1)

# Showing your changes
git diff -U0 '*.nix'

echo "Rebuilding NixOS ..."

# Rebuild script for my flake and outputting simple errors
sudo nixos-rebuild switch --flake ".#$1" >nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation
current=$(nixos-rebuild list-generations | grep current)

# Commit all the changes
git commit -am "$current"

popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
