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
        # Test if the login session exists, if not, create it and leave it detached so we have a baseline session.
        # If so, lock the other terminals out so screen resizing works.
        $TMUX_BIN has-session -t "base" &>/dev/null
        if [[ $? -ne 0 ]]; then
            # Create our base session, we'll never actually connect to this but it'll hold our windows open when ssh isn't connected using exit-unattached
            $TMUX_BIN new-session -d -s "base" -t "ssh" \; set-option exit-unattached off
        else
            #SESSIONS=$(tmux list-sessions -F "#{session_name}:#{session_group}" | grep ":ssh$" | cut -d':' -f1 | awk '{ print "\""$0"\""}')
            #foreach session ($SESSIONS)
            #    $TMUX_BIN lock-client -t "$session"
            #end
            $TMUX_BIN lock-server
        fi
        SESSION="$(echo $SSH_CLIENT | cut -d " " -f 1,2 | tr '.' ',' | tr ':' '#' | tr ' ' '_')"
        $TMUX_BIN -u new-session -s "ssh from $SESSION" -t "ssh" \; set-option destroy-unattached
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

