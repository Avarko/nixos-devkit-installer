#!/bin/bash
die() { echo -e "\e[31m\e[1m\n$@\e[21m\e[0m" 1>&2; exit 1; }
info() { echo -e "\e[35m\e[1m$@\e[21m\e[0m" 1>&2; }

[ $# == 1 ] || die "Usage: `basename "$0"` <secret's path in secret store>"

directory="$(cd "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))" && pwd)"

login() {
	USERID_PATH="$HOME/.config/personal-devkit-nonsecrets/lastpass-userid"
	[[ ! -f "$USERID_PATH" ]] && die "LastPass userid file $USERID_PATH does not exist. Exiting."
	LOGIN_ID="$(cat $USERID_PATH)"
	[[ -z "$LOGIN_ID" ]] && die "LastPass userid in file $USERID_PATH is empty. Exiting."

	info "Logging to LastPass using official LastPass CLI (lastpass-cli) with user id $LOGIN_ID."
	info "After successful MFA authentication, this will create encrypted session data under $HOME/.local/share and start 'lpass [agent]' process."	
	LOGIN_OUTPUT=$(lpass login "$LOGIN_ID")
	info $LOGIN_OUTPUT
}

LPASS_STATUS=$(lpass status)
retValue=$?
if [[ "$retValue" -eq 1 ]] || [[ "$LPASS_STATUS" == "Logged in as (null)." ]]; then
	login
fi

LPASS_STATUS=$(lpass status)
retValue=$?
if [[ "$retValue" -eq 1 ]] || [[ "$LPASS_STATUS" == "Logged in as (null)." ]]; then
	die "Login unsuccessful. Exiting."
fi

SECRET_PATH="$1"

lpass show --notes "$SECRET_PATH"