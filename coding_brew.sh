#!/usr/bin/env bash

cd $HOME

# install command line tools
xcode-select --install

# install Homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# programming environment
brew install vim
brew install git
git config --global user.name "savvas-paragkamian"
git config --global user.email s.paragkamian@gmail.com
git config --global core.editor vim
git config --global init.defaultBranch main
git config --global credential.helper osxkeychain
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global difftool.prompt false

brew install tmux
brew install htop

git clone --recurse-submodules -j8 https://github.com/savvas-paragkamian/.tmux.git
git clone --recurse-submodules -j8 https://github.com/savvas-paragkamian/.vim.git
git clone https://github.com/savvas-paragkamian/.dotfiles.git

# programming languages and packeges
brew install r
Rscript -e 'install.packages("tidyverse", repos="https://cloud.r-project.org")'

brew install julia
brew install python
brew install postgresql
brew install perl
brew install gawk

## latex - basic tex
brew install --cask basictex

## fix path for basictex
export PATH=$PATH:/Library/TeX/texbin

# utilities
brew install pandoc
brew install tesseract
brew install jq
brew install imagemagick

# install the apps
./brew_apps.sh
