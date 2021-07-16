#!/usr/bin/env bash

cd $HOME

# install command line tools
xcode-select --install

# install Homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# programming environment
brew install vim
brew install tmux
brew install htop

# install the apps

# General MacOS Applications
brew install google-chrome
brew install firefox
brew install dropbox
brew install google-backup-and-sync
brew install --cask owncloud

# communication
brew install skype
brew install messenger
brew install --cask viber
brew install --cask zoom

# Programming applications

# Personal applications
brew install --cask adobe-acrobat-reader
brew install handbrake
brew install vlc
brew install --cask microsoft-remote-desktop
brew install --cask the-unarchiver
brew install --cask google-earth-pro

