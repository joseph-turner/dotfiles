#!/bin/bash

# Install Caskroom
brew tap caskroom/cask
brew tap caskroom/fonts
brew tap caskroom/versions

# Install packages
casks=(

  adobe-creative-cloud
  betterzip # Note: The BetterZipQL plugin was integrated with the BetterZip app.
  dropbox
  firefox
  franz
  google-backup-and-sync
  google-chrome
  google-chrome-canary
  iterm2
  kap
  lastpass
  p4merge
  sip
  skitch
  skyfonts
  skype
  slack
  spotify
  suspicious-package # Preview the contents of a standard Apple installer package
  ubersicht
  virtualbox
  visual-studio-code

  # Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
  qlcolorcode # Preview source code files with syntax highlighting
  qlstephen # Preview plain text files without or with unknown file extension. Example: README, CHANGELOG, index.styl, etc.
  qlmarkdown # Preview Markdown files
  quicklook-json # Preview JSON files
  qlimagesize # Display image size and resolution
  webpquicklook # Preview WebP images
  quicklookase # Preview Adobe ASE Color Swatches generated with Adobe Photoshop, Adobe Illustrator, Adobe Color CC, Spectrum, COLOURlovers, Prisma, among many others.
  qlvideo # Preview most types of video files, as well as their thumbnails, cover art and metadata

  # FONTS
  # Patched by Nerd Font
  font-firacode-nerd-font
  font-robotomono-nerd-font
  font-sourcecodepro-nerd-font
)

casks_to_install=()
for i in ${casks[@]}; do
  brew cask list $i 2> /dev/null || casks_to_install+=($i)
done

if [[ ${casks_to_install[@]} ]]; then
  brew cask install "${casks_to_install[@]}"
else
  echo "All casks already installed!"
fi

unset casks casks_to_install
