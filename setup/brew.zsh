#!/bin/zsh

# Installs Homebrew and some of the common dependencies needed/desired for software development

# Ask for the administrator password upfront
# sudo -v

# Check for Homebrew and install it if missing
if ! type brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install the Homebrew packages I use on a day-to-day basis.
#
# - Tree (http://mama.indstate.edu/users/ice/tree/): A directory listing utility
#   that produces a depth indented listing of files.
# - git-extras (https://vimeo.com/45506445): Adds a ton of useful commands #   to git.

formulae=(
  # CLI
  bat
  coreutils
  fzy
  git
  git-extras
  # git-flow
  htop
  # kubernetes-cli
  python # for pip
  ripgrep
  speedtest_cli
  tmux
  trash
  tree
  volta # nodejs version manager (also npn and yarn)
  wget
  yarn

  # Installers and apps
  # adobe-creative-cloud
  docker
  # figma
  # firefox
  franz
  google-drive
  google-chrome
  iterm2
  # lastpass
  # pomello
  postman
  # rocket # Emoji picker (https://matthewpalmer.net/rocket/)
  slack
  spotify
  # ubersicht
  # vanilla # Tool to hide menu bar icons
  visual-studio-code

  # FONTS
  # Patched by Nerd Font
  font-fira-code-nerd-font
  font-iosevka-nerd-font
  font-meslo-lg-nerd-font
  font-monocraft-nerd-font
  font-sauce-code-pro-nerd-font
)

formulae_to_install=()
for i in ${formulae[@]}; do
  # Only try to install the ones that aren't already installed
  brew list $i &> /dev/null && echo "Formula $i already installed!" || formulae_to_install+=($i)
done

if [[ ${formulae_to_install[@]} ]]; then
  brew install "${formulae_to_install[@]}"
else
  echo "All formulae already installed!"
fi

# Remove outdated versions from the cellar
brew cleanup

echo "Configuring iTerm2 keybindings..."
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
