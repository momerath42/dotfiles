# /etc/skel/.bashrc

# NOTE: this file obviously belongs in $HOME - this is a copy in .config for
# sharing my dotfiles - .bash-preexec.sh (which is someone else's unmodified
# work) also belongs in $HOME; just including for completeness (not that just
# copying this repo into .config is likely to work)

#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

# silences a gtk warning about the "accessibility bus"
export NO_AT_BRIDGE=1

# should be done by gentoo; maybe change it globally:
export XDG_CONFIG_HOME=~/.config

export PATH=~/bin/:$PATH

# userland node:
export NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="${NPM_PACKAGES}/lib/node_modules:$NODE_PATH"
export PATH=$PATH:${NPM_PACKAGES}/bin

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# I don't remember why I stopped doing this:
#nvm use --lts

CARGO_BIN=~/.cargo/bin
export PATH=$PATH:$CARGO_BIN

export PATH=$PATH:~/.emacs.d/bin

# default to buildx
export DOCKER_BUILDKIT=1

## better history https://www.thomaslaurenson.com/blog/2018-07-02/better-bash-history/
#HISTTIMEFORMAT='%F %T '
#HISTFILESIZE=-1
#HISTSIZE=-1
#HISTCONTROL=ignoredups
#HISTIGNORE=?:??
# append to history, dont overwrite it
#shopt -s histappend
# attempt to save all lines of a multiple-line command in the same history entry
#shopt -s cmdhist
# save multi-line commands to the history with embedded newlines
#shopt -s lithist
# After each command, append to the history file and reread it
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$"\n"}history -a; history -c; history -r"
# don't reread it, that's annoying; and let's keep things simple - I don't set prompt_command elsewhere
#export PROMPT_COMMAND="history -a"

# wal colors
cat ~/.cache/wal/sequences
source ~/.cache/wal/colors-tty.sh

# non-system rust
#. "$HOME/.cargo/env"

## python venv kludge
if [ -z "$PYTHON_VENV" ]; then
  export PYTHON_VENV="default"
fi
. ~/python-venvs/${PYTHON_VENV}/bin/activate

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/momerath/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/momerath/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/momerath/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/momerath/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

export PATH=$PATH:~/.asdf/bin/
#:~/.asdf/installs/babashka/1.0.164/bin/

# needed for atuin (a better history mechanism; replacing the commented out
# block above)
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

# safer/better than setting it as my default shell; I've forgotten why exactly -
# maybe just that I didn't want to recreate all of the above, or maybe for the
# non-interactive early-out
SHELL=/bin/fish exec /bin/fish

