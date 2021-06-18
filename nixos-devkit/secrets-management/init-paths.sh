#!/bin/bash
die() { echo -e "\e[31m\e[1m\n$@\e[21m\e[0m" 1>&2; exit 1; }
info() { echo -e "\e[35m\e[1m$@\e[21m\e[0m" 1>&2; }

[ $# == 1 ] || die "Usage: `basename "$0"` <secrets paths note suffix in secret store>"

NOTE_SUFFIX=$1
NOTE_SUFFIX=${NOTE_SUFFIX:0:12} # max 12 char length for suffix
NOTE_SUFFIX=${NOTE_SUFFIX//[^a-zA-Z0-9_-]/} # allow only alphanumerics, underscore and dash for suffix
NOTE_SUFFIX=`echo -n $NOTE_SUFFIX | tr A-Z a-z` # lowercase suffices

SECRETSPATHS_FILE="$HOME/.config/personal-devkit-nonsecrets/secretsPaths.json"
directory="$(cd "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))" && pwd)"
SECRETSPATHS=$("$directory/fetch-secret.sh" "personalDevkitEntries/devkitSecretsJson-$NOTE_SUFFIX")

echo $SECRETSPATHS > "$SECRETSPATHS_FILE"
