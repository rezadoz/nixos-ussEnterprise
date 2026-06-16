#!/usr/bin/env bash
ansi_yellow='\033[1;33m'
reset='\033[0m'

lsd --tree /etc/nixos
printf "${ansi_yellow}(1/2) updating flake...${reset}\n"
sudo nix flake update /etc/nixos
printf "${ansi_yellow}(2/2) nixos-rebuild switch...${reset}\n"
sudo nixos-rebuild switch --flake /etc/nixos#uss-enterprise |& nom
