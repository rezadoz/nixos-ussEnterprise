#!/usr/bin/env bash
ansi_yellow='\033[1;33m'
ansi_cyan='\033[1;36m'
ansi_green='\033[1;32m'
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

    time_str=""
    [[ $days -gt 0 ]] && time_str+="${days}d "
    [[ $hours -gt 0 ]] && time_str+="${hours}h "
    [[ $minutes -gt 0 ]] && time_str+="${minutes}m"
    [[ -z "$time_str" ]] && time_str="just now"
    time_str="${time_str%" "}"

    printf "${ansi_cyan}last update ${time_str} ago...${reset}\n"
else
    printf "${ansi_cyan}no update log found — creating one after this run...${reset}\n"
fi

sleep 1
lsd --tree /etc/nixos
printf "${ansi_yellow}(1/2) updating flake...${reset}\n"
sudo nix flake update --flake /etc/nixos
printf "${ansi_yellow}(2/2) nixos-rebuild switch...${reset}\n"

# Capture output while still displaying it through nom
rebuild_output=$(sudo nixos-rebuild switch --flake /etc/nixos#uss-enterprise 2>&1 | tee >(nom))

# Extract version number from the "new configuration" line
version=$(echo "$rebuild_output" | grep -oP '(?<=-uss-enterprise-)\S+')

# Log current epoch timestamp
date +%s > "$LOG_FILE"

# Git commit with version number
if [[ -n "$version" ]]; then
    printf "${ansi_green}(3/3) committing config to git... [${version}]${reset}\n"
    cd /etc/nixos || exit 1
    sudo git add .
    sudo git commit -m "$version"
    sudo git push -u origin master
else
    printf "${ansi_yellow}warning: could not parse version number, skipping git commit${reset}\n"
fi
