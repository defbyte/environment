# Custom $PATH

export USR_PATH="/usr/local/bin:/usr/local/sbin"
export PG_PATH="/Applications/Postgres.app/Contents/Versions/latest/bin"
export NODE_PATH="/usr/local/share/npm/bin"
export OSX_PATH="/usr/bin:/usr/sbin:/bin:/sbin"
export NVM_DIR="$HOME/.nvm"
export PYENV_PATH="$HOME/.pyenv"
export VSCODE_PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export PATH="$PYENV_PATH/bin:$VSCODE_PATH:$PG_PATH:$USR_PATH:$NODE_PATH:$OSX_PATH"
export CDPATH=".:~:~/Projects"

# Activate chruby and the .ruby-version auto-switcher

#source /usr/local/opt/chruby/share/chruby/chruby.sh
#source /usr/local/opt/chruby/share/chruby/auto.sh

# Activate nvm and the .nvmrc version switcher

#source $NVM_DIR/nvm.sh

# Activate pyenv
eval "$(pyenv init -)"