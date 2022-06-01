#!/bin/bash

set -euo pipefail

PRIMARY="\033[0;35m"
LOG="\033[0;36m"
SUCCESS="\033[0;32m"
NC="\033[0m"
BRAND="[stow]"

function log {
    echo -e "${PRIMARY}${BRAND} ${LOG}$1${NC}"
}

function success {
    echo -e "${PRIMARY}${BRAND} ${SUCCESS}$1${NC}"
}

WORK_MACHINE="elmon"
CURRENT_MACHINE="$(hostname)"

DEFAULT_STOW_PKGS="zsh alacritty dircolors starship"

STOW_PKGS=${STOW_PKGS:=$DEFAULT_STOW_PKGS}

for pkg in $STOW_PKGS
do
    log "Stowing $pkg package."
    stow $@ "$pkg"
done

log "Finished stowing general packages."

success "Finished stowing files."