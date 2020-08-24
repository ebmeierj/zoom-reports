#!/bin/bash
set -euox pipefail
cd $(dirname $0)

die () {
  echo >&2 "$@"
  exit 1
}

os_requirements() {
  uname -a | grep -q Darwin >/dev/null 2>&1 || die "This program requires MacOS"
}

git_requirements() {
  which git >/dev/null 2>&1 || install_git
  if [ -f cli.rb ]
  then
    git pull
  elif [ -f zoom-reports/cli.rb ]
  then
    ./zoom-reports/install.sh
    exit $?
  else
    download_source
  fi
}

install_git() {
  echo "Git was not found on your system. Attempting to install with your package manager"
  brew update
  brew install git
}

download_source() {
  git clone -b initial git@github.com:ebmeierj/zoom-reports.git
}

ruby_requirements() {
  which ruby >/dev/null 2>&1 || install_ruby
  which bundle >/dev/null 2>&1 || install_bundler
  bundle check >/dev/null 2>&1 || install_ruby_libraries
}

install_ruby() {
  echo "Ruby was not found on your system. Attempting to install with your package manager"
  brew update
  brew install ruby
}

install_bundler() {
  echo "Installing ruby bundler to manage ruby libraries"
  gem install bundler
}

install_ruby_libraries() {
  echo "Installing ruby libraries"
  bundle install
}

os_requirements
git_requirements
ruby_requirements
