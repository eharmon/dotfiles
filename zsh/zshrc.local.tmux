# Additional pieces for tmux configuration
# If we're inside tmux and we've just created the only pane, show the motd. Because who doesn't love a motd
if [[ ! -z "$TMUX" && $($TMUX_BIN list-windows -t login | wc -l | tr -d ' ') == "1" && -e /etc/motd && "$UID" != 0 ]]
then
	echo
	cat /etc/motd
fi
