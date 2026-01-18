function handle_failure {
    # Try to get back to relatively sane defaults if we crashed in the middle of something strange
    stty sane
    tput cnorm
    echo
    echo "--------------------------------------------------------------------------------"
    echo
    print "\e[0;31mWARNING: There was an error interacting with tmux (or tmux has crashed), starting a standard shell to let you clean up...";
    echo
}

# Make the magic happen if we're not already in tmux
if [ -z "$TMUX" ]
then
    if [[ "$TERM" != screen* && $+commands[tmux] -eq 1 ]]
    then
        # Disable broadcast messages
        mesg n
        # Test if the login session exists, if not, create it and leave it detached so we have a baseline session.
        # If so, lock the other terminals out so screen resizing works.
        tmux has-session -t "base" &>/dev/null
        if [[ $? -ne 0 ]]; then
            # Create our base session, we'll never actually connect to this but it'll hold our windows open when ssh isn't connected using exit-unattached
            tmux new-session -d -s "base" -t "ssh" \; set-option exit-unattached off
        fi

        # The base session should now exist. Double check.
        tmux has-session -t "base" &>/dev/null
        if [[ $? -eq 0 ]]; then
            SESSION="$(echo $SSH_CLIENT | cut -d " " -f 1,2 | tr '.' ',' | tr ':' '#' | tr ' ' '_')"
            tmux -u new-session -s "ssh from $SESSION" -t "ssh" \; set-option destroy-unattached
            if [[ $? == 0 ]]; then
                # See if we should suspend on exit
                # TODO: Wait 30 seconds and run in background
                $HOME/.tmux-suspend.sh
                exit
            else
                handle_failure
            fi
        else
            handle_failure
        fi
    fi
fi

unfunction handle_failure

