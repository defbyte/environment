# -----------------------------------------------------------------------------
# HEROKU
# -----------------------------------------------------------------------------

# Shorthand commands
alias fs="foreman start"
alias fr="foreman run"
alias hc="heroku run rails console"
alias htail="heroku logs --tail"
alias hps="heroku ps"
alias hadd="heroku config:add"

# Print out the Heroku config as if it was a .env file
function henv {
  heroku config | sed -E "s/:[[:space:]]+/=/g" | tail -n +2
}

# Migrate Heroku DB and restart
function hmigrate {
  heroku pgbackups:capture --expire && \
  heroku run rake db:migrate && \
  heroku restart
}

# Turn the Heroku app on and off quickly
function hoff {
  heroku scale web=0 && \
  heroku maintenance:on
}

# Turn the Heroku app on and off quickly
function hon {
  heroku scale web=1 && \
  heroku maintenance:off
}

# Deploy to Heroku, with optional extra commands, ex:
# hdeploy
# hdeploy migrate
# hdeploy seed administrators
function hdeploy {
  if [[ "$1" = "migrate" ]]; then
    git push github && \
    heroku maintenance:on && \
    heroku pgbackups:capture --expire && \
    git push heroku && \
    heroku run rake db:migrate && \
    heroku restart && \
    heroku maintenance:off
  elif [[ "$1" = "seed" && -n "$2" ]]; then
    git push github && \
    heroku maintenance:on && \
    heroku pgbackups:capture --expire && \
    git push heroku && \
    heroku run rake db:migrate && \
    heroku run rake db:seed_fu FILTER=$2 && \
    heroku restart && \
    heroku maintenance:off
  else
    git push github && \
    git push heroku
  fi
}

# Print out the Heroku config as if it was a .env file
function henv () {
  heroku config | sed -E "s/:[[:space:]]+/=/g" | tail -n +2
}


# -----------------------------------------------------------------------------
# POSTGRES
# -----------------------------------------------------------------------------

# Dump a local database
function dumpdb {
  pg_dump --clean --format=custom --no-acl --verbose --file=$1.dump $1 && \
  echo "✔ Written to ./$1.dump"
}

# Restore a database locally
# https://devcenter.heroku.com/articles/heroku-postgres-import-export
alias restoredb="pg_restore --verbose --clean --no-acl --no-owner -d"

# Dump the current heroku production database to a file
function hdump {
  heroku pgbackups:capture --expire && \
  wget -O ~/Downloads/latest.dump `heroku pgbackups:url` && \
  echo "✔ Written to ~/Downloads/latest.dump"
}

# Download the current Heroku database and replace the local one
function hpgpull {
  dropdb $1
  heroku pg:pull DATABASE $1 && \
  echo "✔ Local database $1 overwritten with production data"
}

# Drop and create a local database. will use whoami for owner name if none passed as second arg
function recreatedb {
  dbowner=`whoami`
  if [ -z "$1" ]; then
	  echo "First argument must be database name."
  else
    if [ ! -z "$2" ]; then
      dbowner=$2
    fi
    dropdb $1
    createdb -O $dbowner $1 --encoding="utf-8" --template="template0"
    echo "✔ Local database $1 recreated with $dbowner owner"
  fi
}

# -----------------------------------------------------------------------------
# RAILS
# -----------------------------------------------------------------------------

# Shorthand commands
alias be="bundle exec"

function lb {
  bundle install --path ./vendor/bundle && \
  bundle exec rake rails:update:bin
}

# Update the bundle and clean out old cached gems
function bu {
  bundle update && \
  bundle clean
}

# Create a Rails migration and open it
function migration {
  bundle exec rails generate migration $1 && \
  mate db/migrate/`ls -t db/migrate/ | head -1`
}

# Remove the configured bundle from this Rails project folder
function lb-implode {
  echo "Destroying your local bundle"
  echo "Removing ./vendor/bundle"
  rm -rf ./vendor/bundle
  echo "Removing ./.bundle"
  rm -rf ./.bundle
  echo "Removing Gemfile.lock"
  rm -f Gemfile.lock
}

# Get started with a news Rails project quickly
# Creates unversioned files and springs them open
function railsup {

  echo "Setting git config for core.filemode and core.ignorecase"
  git config core.filemode false
  git config core.ignorecase false

  echo "Creating .env"
  echo "PORT=8080" >> ".env"
  echo "DATABASE_URL=postgres://localhost/DATABASE" >> ".env"
  echo "RACK_ENV=development" >> ".env"
  echo "RAILS_ENV=development" >> ".env"
  mate "."
  mate ".env"

  echo "Creating tmp/cache"
  mkdir "tmp"
  mkdir "tmp/cache"
  touch "tmp/cache/.gitkeep"

  echo "Creating log/development.log"
  mkdir "log"
  touch "log/development.log"

  echo "Installing bundle..."
  lb

}

function uninstall-all-gems {
  for i in `gem list --no-versions`; do gem uninstall -aIx $i; done
}

# -----------------------------------------------------------------------------
# PYTHON
# -----------------------------------------------------------------------------

# Alias Python 2.6 - we will have Python 2.6 and 2.7 living together via Homebrew
alias python26="/usr/local/Cellar/python26/2.6.9/bin/python2.6"

# -----------------------------------------------------------------------------
# DJANGO
# -----------------------------------------------------------------------------

# Shorthand commands
alias manage="python manage.py"
alias localpip="pip install -r requirements.txt"
alias runserver="manage runserver 0.0.0.0:8000"

function mkvenv26 {
  if [ -z "$1" ] ; then
    echo "Please supply the directory name to crete the venv"
  else
    virtualenv --distribute --no-site-packages --python=/usr/local/Cellar/python26/2.6.9/bin/python2.6 $1
  fi
}

function mkvenv27 {
  if [ -z "$1" ] ; then
    echo "Please supply the directory name to crete the venv"
  else
    virtualenv --distribute --no-site-packages --python=python2.7 $1
  fi
}

# Activate the venv, but give me back my pretty prompt
function venv {
  source venv/bin/activate
  export PS1="\n\[$(tput setaf 2)\]VIRTUAL ⚡ \[$(tput sgr0)\]"
}

# -----------------------------------------------------------------------------
# OSX/UNIX
# -----------------------------------------------------------------------------

# Shorthand
alias la="ls -lA"
alias ax="chmod a+x"

# Create a 2048-bit certificate key and CSR
function gen-csr {
  openssl genrsa -des3 -out server.locked.key 2048 && \
  openssl rsa -in server.locked.key -out server.key && \
  rm server.locked.key && \
  openssl req -nodes -new -key server.key -out server.csr
}

# Change to personal ~/workspace folder
function p () {
  cd $HOME/workspace
  pwd
}

# Create and cd to a directory
function mcd () {
  mkdir -p "$1" && cd "$1";
}

# Touch and open a file
function tmate () {
  touch "$1" && mate "$1";
}

# Print your LAN IPv4 address
function localip () {
  (awk '{print $2}' <(ifconfig en0 | grep 'inet '));
}

# Print your LAN IPv6 address
function localipv6 () {
  (awk '{print $2}' <(ifconfig en0 | grep 'inet6 '));
}

# Generate some URL/MySQL safe random characters for keys/passwords
function random () {
  ruby -e "require 'securerandom'; puts SecureRandom.urlsafe_base64(512).gsub(/[-_]/,'')"
}

# Extract nearly any command-line archive
function extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)  tar xjf $1     ;;
      *.tar.gz)   tar xzf $1     ;;
      *.bz2)      bunzip2 $1     ;;
      *.rar)      unrar e $1     ;;
      *.gz)       gunzip $1      ;;
      *.tar)      tar xf $1      ;;
      *.tbz2)     tar xjf $1     ;;
      *.tgz)      tar xzf $1     ;;
      *.zip)      unzip $1       ;;
      *.Z)        uncompress $1  ;;
      *.7z)       7z x $1        ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
      esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Show a list of computers currently listening to your iTunes library
function ituners () {
  lsof | grep iTunes | grep TCP
}

# Flush OS X's DNS caches
function flushdns () {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

# Removes duplicates from the "Open With" menu in OS X
# http://bit.ly/eF8UHG
function fix-launch-services () {
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
  killall Finder
}

# Print your public IPv4 address
function publicip () {
  curl -s http://whatismyip.akamai.com/;
  printf "\n";
}

# Quit an OS X application from the command line
function quit () {
  for app in $*; do
    osascript -e 'quit app "'$app'"'
  done
}

# Relaunch an OS X application from the command line
function relaunch () {
  for app in $*; do
    osascript -e 'quit app "'$app'"';
    sleep 2;
    open -a $app
  done
}

function ohchrome {
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" "http://0.0.0.0:8080" &> /dev/null
}
