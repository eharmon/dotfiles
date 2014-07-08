# Kill XOFF, it is evil.
stty stop undef

# Use var to allow us to move tmux around
TMUX_BIN=`which tmux`

# If we're using homebrew on an NFS homedir, cache tmux
if is_nfs_homedir
then
    if [[ -e ~/.homebrew/bin/tmux ]]
    then
        TMUX_BIN=/tmp/tmux-$USER
        cp ~/.homebrew/bin/tmux $TMUX_BIN 2>/dev/null
    fi
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
        SESSION="$(echo $SSH_CLIENT | cut -d " " -f 1,2 | tr '.' '-')"
        # TODO: Guess color support based on term title
        $TMUX_BIN -2 -u new-session -s "$SESSION" -t "login"
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

