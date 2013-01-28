# Don't spawn a new shell when we login
NEW_SHELL_ON_LOGIN=0

# Kill XOFF, it is evil.
stty stop undef

# First we copy our local copy of tmux into tmp, this prevents NFS interruptions from hanging tmux
TMUX_BIN=/tmp/tmux-$USER

if [[ ! -e $TMUX_BIN && -e ~/.homebrew/bin/tmux ]]
then
        cp ~/.homebrew/bin/tmux $TMUX_BIN
fi

# Make the magic happen if we're not already in tmux
if [ -z "$TMUX" ]
then
	if [[ "$TERM" != screen* ]]
	then
		# Disable broadcast messages
		mesg n
		# Test if the login session exists, if not, create it, if so, lock the other terminals out so screen resizing works/for privacy
		$TMUX_BIN has-session -t "login" &>/dev/null 
		if [[ $? -ne 0 ]]; then
			$TMUX_BIN -u -2 new-session -d -s "login"
		else
			$TMUX_BIN lock-server
		fi
		SESSION="$(echo $SSH_CLIENT | cut -d " " -f 1,2)"
		# We're forcing 256-color support here, not the smartest thing ever
		$TMUX_BIN -u new-session -s "$SESSION" -t "login"
		# Once we're done, kill the session, just in case the person just detaches
		#$TMUX_BIN kill-session -t "$SESSION"
		if [[ $? == 0 ]]; then
			exit
		else
			echo
			echo "--------------------------------------------------------------------------------"
			echo
			print "\e[0;31mWARNING: There was an error interacting with tmux (or tmux has crashed), starting a standard shell to let you clean up...";
			echo
		fi
	fi
fi
return

