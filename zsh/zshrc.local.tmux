# Additional pieces for tmux configuration
# If we're inside tmux and we've just created the only pane, show the motd. Because who doesn't love a motd
if [[ ! -z "$TMUX" && $(tmux list-windows -t "base" | wc -l | tr -d ' ') == "1" && -e /etc/motd && "$UID" != 0 ]]
then
	echo
	cat /etc/motd
fi
