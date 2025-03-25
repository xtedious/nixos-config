#!/usr/bin/env bash

# Update script that could honestly be automated to update every 7 days but nixos unstable is very unstable so NOOOOOOO!!!

# Collect any garbage
nix-collect-garbage -d

# Update the flake
echo "Updating the flake and pkg repos ..."

sudo nix flake update

echo "Rebuilding NixOS ..."

# Rebuild script for my flake and outputting simple errors
sudo nixos-rebuild switch --flake ".#$1" >nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
