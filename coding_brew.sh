#!/usr/bin/env bash

# install command line tools
xcode-select --install

# install Homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew for coding
brew install r
brew install python
brew install postgresql
brew install perl

brew install pandoc

