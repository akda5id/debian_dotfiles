# ~/.bashrc - If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# == Greeting ==

if [[ -x "${HOME}/.local/bin/fortune" ]]; then
    ${HOME}/.local/bin/fortune ${HOME}/.fortunes
fi

# == Prompt ==

# Colour codes
RED="\\[\\e[1;31m\\]"
GREEN="\\[\\e[1;32m\\]"
YELLOW="\\[\\e[1;33m\\]"
BLUE="\\[\\e[1;34m\\]"
MAGENTA="\\[\\e[1;35m\\]"
CYAN="\\[\\e[1;36m\\]"
WHITE="\\[\\e[1;37m\\]"
RESET="\\[\\e[0m\\]"

# Set a two-line prompt; if accessing via ssh include 'ssh-session' message
if [[ -n "$SSH_CLIENT" ]]; then
    ssh_message="-ssh_session"
fi
PS1="${GREEN}\\u ${WHITE}at ${YELLOW}\h${RED}${ssh_message} ${WHITE}in ${BLUE}\\w \\n$WHITE\$${RESET} "

# == Functions ==

# Backup and timestamp files
bak() { for f in "$@" ; do cp -- "$f" "$f.$(date +%FT%H%M%S).bak" ; done ; }

# Change directories and list contents
c() { cd -- "$@" && ls -aFlh --color=always ; }

# Top 10 most used commands
cmd10() { history | awk '{print $3}' | sort | uniq -c | sort -rn | head ; }

# Make directory and change to it immediately
md() { mkdir -p -- "$@" && cd -- "$@" || return ; }

# Replace spaces and non-ascii characters in a filename with underscore
mtg() { for f in "$@" ; do mv -- "$f" "${f//[^a-zA-Z0-9\.\-]/_}" ; done ; }

# (Un)mount usb devices
mu() { sudo mountusb -m $1 ; }
umu() { sudo mountusb -u $1 ; }
# LUKS-encrypted usb device
muc() { sudo cryptset -o $1 && sudo mountusb -m $1 ; }
umuc() { sudo mountusb -u $1 && sudo cryptset -c $1 ; }

# == Aliases ==

alias aaa="sudo apt update && apt list --upgradable && sudo apt full-upgrade && sudo apt-get autoclean && sudo apt autoremove"
alias arst="setxkbmap us"
alias asdf="setxkbmap us -variant colemak"
alias bye="sudo systemctl poweroff"
alias dff="df -hT --total"
alias dpkgg="dpkg -l | grep -i"
alias e="nvim"
alias gpush="git push -u origin master"
alias gsave="git commit -m 'save'"
alias gs="git status"
alias l="ls -aFlhv --color=always"
alias lsmount="mount | column -t"
alias myip="ip -f inet address | grep inet | grep -v 'lo$' | cut -d ' ' -f 6,13 && curl ifconfig.me && echo ' external ip'"
alias p="less"
alias psg='ps aux | grep'
alias reboot="sudo systemctl reboot"
alias t="c ~/tmp"
alias tmuxd="tmux new -s default -A"
alias x="exit"
alias yta="youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 --restrict-filenames"
alias zzz="systemctl suspend"

if [[ -f ~/.bash_aliases ]]; then
    # shellcheck source=/dev/null
    . ~/.bash_aliases
fi

# == History ==

# Unlimited history
HISTSIZE=
HISTFILESIZE=

# Change the history file location because certain bash sessions truncate
# ~/.bash_history upon close
HISTFILE=~/.bash_unlimited_history

# Default is to write history at the end of each session, overwriting the
# existing file with an updated version. If logged in with multiple sessions,
# only the last session to exit will have its history saved.
#
# Require  prompt write to history after every command and append to the
# history file, don't overwrite it.
shopt -s histappend
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# Now you can see the commands from all shells in near real-time in
# ~/.bash_unlimited history. Starting a new shell displays the
# combined history from all terminals.

# Add a timestamp per entry. Useful for context when viewing logfiles
HISTTIMEFORMAT="%FT%T  "

# Save all lines of a multiple-line command in the same history entry
shopt -s cmdhist

# Re-edit a history substitution line if it failed
shopt -s histreedit

# Edit a recalled history line before executing
shopt -s histverify

# Do not put lines starting with space in the history
HISTCONTROL=ignorespace

# Toggle history off/on for a current shell
alias stophistory="set +o history"
alias starthistory="set -o history"

# Helpful!
# https://superuser.com/q/575479
# https://unix.stackexchange.com/q/1288

# == Misc ==

# PROMPT_COMMAND sets the terminal title bar.
export PROMPT_COMMAND='printf "\033]0;%s at %s\007" "${USER}" "${HOSTNAME%%.*}"'

# When resizing a terminal emulator, check the window size after each command
# and, if necessary, update the values of LINES and COLUMNS. 
shopt -s checkwinsize

# Set colours
eval `dircolors`

# Use `keychain` for ssh-agent management
if [[ -x /usr/bin/keychain ]]; then
	keychain ~/.ssh/id_ed25519
	. "${HOME}/.keychain/${HOSTNAME}-sh"
fi

# Disable XON/XOFF flow control. Enables use of C-S in other commands.
# Examples: forward search in history; disable screen freeze in vim.
stty -ixon

# Bash completion.
if [[ -f /etc/profile.d/bash_completion.sh ]]; then
    # shellcheck source=/dev/null
    . /etc/profile.d/bash_completion.sh
fi

# Automatically search the official repositories when entering an unrecognized
# command.
if [[ -f /usr/share/doc/pkgfile/command-not-found.bash ]]; then
    # shellcheck source=/dev/null
    . /usr/share/doc/pkgfile/command-not-found.bash
fi
