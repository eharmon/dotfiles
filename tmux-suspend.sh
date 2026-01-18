#!/bin/bash

if [[ -e ~/.config/dotfiles/enable_suspend_on_disconnect ]]; then
	if [[ -z "$(tmux list-clients)" ]]; then
		echo "$(date): should be suspending" >> /tmp/suspend_log
		# You must add the following to sudoers. This may have security implications, only tested on non-critical systems:
		# <username> ALL= NOPASSWD: /usr/bin/systemctl suspend
		sudo systemctl suspend
	fi
fi
