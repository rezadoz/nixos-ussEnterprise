#!/usr/bin/env bash
ansi_yellow='\033[1;33m'
ansi_cyan='\033[1;36m'
reset='\033[0m'

LOG_FILE="$HOME/.update.log"

# Print time since last update
if [[ -f "$LOG_FILE" ]]; then
    last_epoch=$(cat "$LOG_FILE")
    now_epoch=$(date +%s)
    diff=$(( now_epoch - last_epoch ))

    days=$(( diff / 86400 ))
    hours=$(( (diff % 86400) / 3600 ))
    minutes=$(( (diff % 3600) / 60 ))

    printf "${ansi_cyan}last update ${days}d ${hours}h ${minutes}m ago...${reset}\n"
else
    printf "${ansi_cyan}no update log found — creating one after this run...${reset}\n"
fi

sleep 1
lsd --tree /etc/nixos
printf "${ansi_yellow}(1/2) updating flake...${reset}\n"
sudo nix flake update --flake /etc/nixos
printf "${ansi_yellow}(2/2) nixos-rebuild switch...${reset}\n"
sudo nixos-rebuild switch --flake /etc/nixos#uss-enterprise |& nom

# Log current epoch timestamp
date +%s > "$LOG_FILE"
