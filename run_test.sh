#!/bin/bash
#set
#set -x
TODAY=$(date)
HOST=$(hostname)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

echo "-----------------------------------------------------"
echo "Date: $TODAY                     Host:$HOST"
echo "-----------------------------------------------------"
#Change into your directory
cd /home/n07028/AppleCapy/features_appletv/
echo "You're currently in directory"
pwd

bundle install
cucumber "Environment="$1""