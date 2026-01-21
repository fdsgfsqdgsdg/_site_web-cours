#!/bin/bash

# Script de mis a jour
apt update
apt upgrade
apt clean
apt autoclean
apt purge
apt autoremove
# pour Ubuntu seulement
killall snap-store
snap refresh
snap list --all | awk '/désactivé|disabled/{print $1, $3}' | while read -r snapname revision; do echo $snapname $revision; sudo snap remove "$snapname" --revision="$revision"; done
snap list --all | awk '/désactivé|disabled/{print}'
