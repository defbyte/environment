# -----------------------------------------------------------------------------
# HEROKU
# -----------------------------------------------------------------------------

# Shorthand commands
alias hc="heroku run rails console"
alias htail="heroku logs --tail"
alias hgit="heroku git:remote --ssh-git"
alias h="heroku"
alias hr="heroku rake"

# Migrate Heroku DB and restart
function hmigrate {
  heroku pg:backups capture && \
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
    heroku pg:backups capture && \
    git push heroku && \
    heroku run rake db:migrate && \
    heroku restart && \
    heroku maintenance:off
  elif [[ "$1" = "seed" && -n "$2" ]]; then
    git push github && \
    heroku maintenance:on && \
    heroku pg:backups capture && \
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
function henv {
  heroku config --shell
}

# Empty the Heroku repo cache and force-rebuild the application
function hrebuild {
  heroku repo:purge_cache && \
  heroku repo:reset && \
  git push heroku master
}

# -----------------------------------------------------------------------------
# POSTGRES
# -----------------------------------------------------------------------------

# Restore a database locally
# https://devcenter.heroku.com/articles/heroku-postgres-import-export
alias restoredb="pg_restore --verbose --no-acl --no-owner -d"

# Dump a local database
function dumpdb {
  pg_dump --verbose --format=custom --compress=9 --database $1 > ./$1.dump && \
  echo "✔ Written to ./$1.dump"
}

# Dump the current Heroku production database to a file
function hdump {
  heroku pg:backups capture && \
  wget -O ~/Downloads/latest.dump `heroku pg:backups public-url` && \
  echo "✔ Written to ~/Downloads/latest.dump"
}

# Download the current Heroku database and replace the local one
# Force all local clients to disconnect before dropping
function hpgpull {
  psql --command "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$1'" &> /dev/null
  dropdb $1
  heroku pg:pull DATABASE_URL $1 && \
  echo "✔ Local database $1 overwritten with Heroku data"
}

# -----------------------------------------------------------------------------
# RAILS/RUBY
# -----------------------------------------------------------------------------

# Shorthand commands
alias r="rake"
alias rt="rake test"
alias spec="bundle exec rspec spec"
alias fs="foreman start web"
alias fsa="foreman start"
alias be="bundle exec"
alias fr="foreman run"

# Install a version of MRI with ruby-install
function chruby-install {
  ruby-install --src-dir /tmp --cleanup --no-install-deps ruby $1 -- --with-jemalloc && \
  source ~/.profile && \
  chruby $1 && \
  gem update --system && \
  gem install --no-ri --no-rdoc rails rake bundler rack sass foreman buckler down
}

# Update the current bundle
function bu {
  gem update bundler > /dev/null 2>&1 # Silently!
  bundle config ignore_messages true
  bundle update --jobs `sysctl -n hw.ncpu`
}

# Install the Gemfile.lock bundle
function bi {
  gem update bundler > /dev/null 2>&1 # Silently!
  bundle config ignore_messages true
  bundle install --jobs `sysctl -n hw.ncpu`
}

# Remove the ./vendor/bundle and install to system
function bi-migrate {
  echo "Removing ./vendor/bundle"
  rm -rf ./vendor/bundle
  echo "Removing ./.bundle"
  rm -rf ./.bundle
  rmdir ./vendor # Remove ./vendor only if it's empty
  lb
}

# Remove the bundle and Gemfile.lock from this Ruby project folder
function lb-implode {
  echo "Destroying your local bundle"
  echo "Removing ./vendor/bundle"
  rm -rf ./vendor/bundle
  echo "Removing ./.bundle"
  rm -rf ./.bundle
  echo "Removing Gemfile.lock"
  rm -f Gemfile.lock
}

# Create a Rails migration and open it
function migration {
  bundle exec rails generate migration $1 && \
  atom db/migrate/`ls -t db/migrate/ | head -1`
}

# Uninstalls everything in `gem list`
function uninstall-all-gems {
  for name in `gem list --no-versions`;
    do gem uninstall --all --force --executables $name;
  done
}

# -----------------------------------------------------------------------------
# NODE/YARN
# -----------------------------------------------------------------------------

# Remove the ./node_modules folder and re-install it
function yarn-implode {
  rm -rf ./node_modules && \
  yarn install
}

# -----------------------------------------------------------------------------
# OSX/UNIX/MISC
# Sources:
# https://github.com/guarinogabriel/mac-cli
# -----------------------------------------------------------------------------

# Shorthand
alias la="ls -hAlt"
alias lah="ls -lAh"
alias ax="chmod a+x"

# Create a certificate key and CSR.
# The server provided is only used to help set file names.
# Example: $ gen-csr example.com
function gen-csr {
  openssl genrsa -aes256 -passout pass:discarded -out ${1:-server}.locked.key 2048 && \
  openssl rsa -in ${1:-server}.locked.key -passin pass:discarded -out ${1:-server}.key && \
  rm ${1:-server}.locked.key && \
  openssl req -nodes -new -key ${1:-server}.key -out ${1:-server}.csr
}

# Convenience function for opening an s_client session with the server in $1
# Example: $ sc example.com
function sc {
  openssl s_client -connect $1:443 -servername $1 "${@:2}"
}

# Update Homebrew, packages, and clean up old trash
function brew-sync {
  brew update
  brew upgrade
  brew cleanup -s
  brew cask cleanup
  brew prune
}

# Remove files in the current folder that are conflicted from Dropbox
function remove-conflicted-copies {
  find ./ -name "*conflicted copy*" -depth -exec rm {} \;
}

# Find biggest directories in current directory
function find-biggest-directories {
  find . -type d -print0 | xargs -0 du | sort -n | tail -20 | cut -f2 | xargs -I{} du -sh {}
}

# Find biggest files in current directory
function find-biggest-files {
  find . -type f -print0 | xargs -0 du | sort -n | tail -20 | cut -f2 | xargs -I{} du -sh {}
}

# Find all files below the current directory with a given string in their name
function find-name {
  find . -maxdepth 100 -name "*$1*" -print
}

# Lock the screen in OS X
function lock {
  /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
}

# Moves all files in subdirectories of this directory up to the current level
function flatten-cwd {
  find . -mindepth 2 -type f -exec mv -i '{}' . ';'
}

# Create and cd to a directory
function mcd {
  mkdir -p "$1" && cd "$1"
}

# Touch and open a file
function topen {
  touch "$1" && $EDITOR "$1"
}

# Print your LAN IPv4 address
function localip {
  (awk '{print $2}' <(ifconfig en0 | grep 'inet '))
}

# Print your LAN IPv6 address
function localipv6 {
  (awk '{print $2}' <(ifconfig en0 | grep 'inet6 '))
}

# Print your public IPv4 address
function publicip {
  curl -s https://ipinfo.io/ip
}

# Removes duplicates from the "Open With" menu in OS X
# http://bit.ly/eF8UHG
function fix-launch-services {
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && \
  killall Finder
}
