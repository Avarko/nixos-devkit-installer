#!/bin/bash
die() { echo -e "\e[31m\e[1m\n$@\e[21m\e[0m"; exit 1; }
info() { echo -e "\e[35m\e[1m$@\e[21m\e[0m"; }

directory="$(cd "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))" && pwd)"

USERID_PATH="$HOME/.config/personal-devkit-nonsecrets/lastpass-userid"
[[ ! -f "$USERID_PATH" ]] && die "LastPass userid file $USERID_PATH does not exist. Exiting."
LOGIN_ID="$(cat $USERID_PATH)"
[[ -z "$LOGIN_ID" ]] && die "LastPass userid in file $USERID_PATH is empty. Exiting."

info "Logging to LastPass using official LastPass CLI (lastpass-cli) with user id $LOGIN_ID."
info "After successful MFA authentication, this will create encrypted session data under $HOME/.local/share until you call logout.sh."
info "Remember to logout afterwards"
lpass login "$LOGIN_ID"
