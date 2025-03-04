##### Minimal bashrc which works with our vim config on old machines

# Some machines may need the following .bash_profile:
#  [[ -s ~/.bashrc ]] && source ~/.bashrc

source .bashrc.detect_old_unix
export OLD_UNIX
