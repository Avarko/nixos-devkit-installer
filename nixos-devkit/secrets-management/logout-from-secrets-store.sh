#!/bin/bash
info() { echo -e "\e[35m\e[1m$@\e[21m\e[0m"; }

info "Removing the LastPass session data in $HOME/.local/share/lpass..."
lpass logout
rm -rf "$HOME/.local/share/lpass"
info "Done."
