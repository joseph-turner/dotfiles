#!/bin/bash

# Install Caskroom
brew tap caskroom/cask
brew tap caskroom/fonts
brew tap caskroom/versions

# Install packages
casks=(

  # Installers and apps
  adobe-creative-cloud
  # bettertouchtool
  betterzip # Note: The BetterZipQL plugin was integrated with the BetterZip app.
  docker
  dropbox
  firefox
  franz
  google-backup-and-sync
  google-chrome
  iterm2
  kap
  lastpass
  p4merge
  skitch
  # skyfonts
  # skype
  # slack
  spotify
  suspicious-package # Preview the contents of a standard Apple installer package
  ubersicht
  # virtualbox
  visual-studio-code-insiders
  zeplin

  # Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
  qlcolorcode # Preview source code files with syntax highlighting
  qlimagesize # Display image size and resolution
  qlmarkdown # Preview Markdown files
  qlstephen # Preview plain text files without or with unknown file extension. Example: README, CHANGELOG, index.styl, etc.
  qlvideo # Preview most types of video files, as well as their thumbnails, cover art and metadata
  quicklook-json # Preview JSON files
  quicklookase # Preview Adobe ASE Color Swatches generated with Adobe Photoshop, Adobe Illustrator, Adobe Color CC, Spectrum, COLOURlovers, Prisma, among many others.
  webpquicklook # Preview WebP images

  # FONTS
  # Patched by Nerd Font
  font-firacode-nerd-font
  font-robotomono-nerd-font
  font-sourcecodepro-nerd-font
)

casks_to_install=()
for i in ${casks[@]}; do
  brew cask list $i &> /dev/null && echo "Cask $i already installed!" || casks_to_install+=($i)
done

if [[ ${casks_to_install[@]} ]]; then
  brew cask install "${casks_to_install[@]}"
else
  echo "All casks already installed!"
fi

unset casks casks_to_install
