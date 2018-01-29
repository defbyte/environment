# Custom $PATH

export USR_PATH="/usr/local/bin:/usr/local/sbin"
export PG_PATH="/Applications/Postgres.app/Contents/Versions/latest/bin"
export NODE_PATH="/usr/local/share/npm/bin"
export OSX_PATH="/usr/bin:/usr/sbin:/bin:/sbin"

export PATH="$USR_PATH:$PG_PATH:$NODE_PATH:$OSX_PATH"

# Activate rbenv
export RBENV_ROOT="/usr/local/var/rbenv"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
