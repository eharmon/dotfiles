# Additional pieces for tmux configuration
# If we're inside tmux and we've just created the only pane, show the motd. Because who doesn't love a motd
if [[ ! -z "$TMUX" && "$UID" != 0 && $(tmux display-message -p -t "base" '#{session_windows}') == "1" ]]; then
	motd
fi
