# Colors please
export CLICOLOR=1

# Big, big history
export HISTSIZE=10000
export HISTFILESIZE=$HISTSIZE

# Don't store duplicate entires
export HISTCONTROL=ignoredups:erasedups

# Make some commands not show up in history
export HISTIGNORE="open:open *:ls:ls *:cd:cd *:pwd;exit:date:* --help:heroku config*:wget *:curl *"

# Append to history, don't overwrite it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Editor, use TextMate
export EDITOR="/usr/local/bin/mate -w"

# Don't clear the screen after quitting a manual page
export MANPAGER="less --no-init"

# Disable Spring for all Rails applcations
export DISABLE_SPRING="true"

# Let GPG know where the tty is
#export GPG_TTY=$(tty)

# Configure Git committer and GPG settings.
# A few programs seem to be unsetting this, so set it on new sessions.
git config --global user.name "Chris Davis"
git config --global user.email "defbyte@gmail.com"
#git config --global commit.gpgsign true
#git config --global user.signingkey "XXX"

# Commands that run each time a prompt is generated
export PROMPT_COMMAND="prompt-command; $PROMPT_COMMAND"
function prompt-command {
  # Save and reload the history after each command finishes
  # this lets multiple terminal windows work on the history together
  history -a;
  history -c;
  history -r;
  # Set window title to be the current directory
  echo -ne "\033]0;${PWD##*/}\007";
}

# Bash Completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# OpenSSL Compiler Flags
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"

# Require Virtualenv for pip install anything
export PIP_REQUIRE_VIRTUALENV=true
