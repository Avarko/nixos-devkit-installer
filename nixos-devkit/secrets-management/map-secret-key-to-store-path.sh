#!/bin/bash
die() { echo -e "\e[31m\e[1m\n$@\e[21m\e[0m"; exit 1; }
info() { echo -e "\e[35m\e[1m$@\e[21m\e[0m"; }

SECRETSPATHS_FILE="$HOME/.config/personal-devkit-nonsecrets/secretsPaths.json"

[ $# == 1 ] || die "Usage: `basename "$0"` <key in $SECRETSPATHS_FILE>"

[[ ! -f "$SECRETSPATHS_FILE" ]] && die "File $SECRETSPATHS_FILE does not exist. Exiting."

SECRET_KEY=$1

SECRET_PATH="$(cat $SECRETSPATHS_FILE | jq -e -r ."$1")"
retValue=$?
if [[ ! "$retValue" -eq 0 ]]; then
	die "Secret key $SECRET_KEY not found in $SECRETSPATHS_FILE"
fi

echo "$SECRET_PATH"
