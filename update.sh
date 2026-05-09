#!/usr/bin/env bash

updater_prior_dir="$(pwd)"
cd /etc/nixos || { echo "f-failed to cd into /etc/nixos ?!"; exit 1; }
lsd --tree

# ANSI yellow
ansi_yellow='\033[1;33m'
reset='\033[0m'

# 4. Yellow status message
printf "${ansi_yellow}(1/2) updating nix-channel...${reset}\n"

# 5. Update nix channels
sudo nix-channel --update

# 6. Yellow status message
printf "${ansi_yellow}(2/2) nixos-rebuild switch...${reset}\n"
sudo nixos-rebuild switch |& nom

# 7. Return to the original working directory
cd "$updater_prior_dir"
