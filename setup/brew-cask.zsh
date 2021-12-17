#!/bin/zsh

# Install Caskroom
brew tap homebrew/cask
brew tap homebrew/cask-fonts
brew tap homebrew/versions

# Install packages
casks=(

  # Installers and apps
  adobe-creative-cloud
  betterzip # Note: The BetterZipQL plugin was integrated with the BetterZip app.
  docker
  figma
  firefox
  franz
  google-drive
  google-chrome
  # harvest # time tracking/invoicing
  iterm2
  lastpass
  # plex
  # plex-media-player
  # plex-media-server
  pomello
  rocket # Emoji picker (https://matthewpalmer.net/rocket/)
  slack
  spotify
  suspicious-package # Preview the contents of a standard Apple installer package
  ubersicht
  visual-studio-code

  # Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
  qlcolorcode # Preview source code files with syntax highlighting
  qlimagesize # Display image size and resolution
  qlmarkdown # Preview Markdown files
  qlstephen # Preview plain text files without or with unknown file extension. Example: README, CHANGELOG, index.styl, etc.
  qlvideo # Preview most types of video files, as well as their thumbnails, cover art and metadata
  quicklook-json # Preview JSON files
  # quicklookase # Preview Adobe ASE Color Swatches generated with Adobe Photoshop, Adobe Illustrator, Adobe Color CC, Spectrum, COLOURlovers, Prisma, among many others.
  webpquicklook # Preview WebP images
)

casks_to_install=()
for i in ${casks[@]}; do
  brew list --cask $i &> /dev/null && echo "Cask $i already installed!" || casks_to_install+=($i)
done

if [[ ${casks_to_install[@]} ]]; then
  brew install --cask "${casks_to_install[@]}"
else
  echo "All casks already installed!"
fi

fonts=(
  # FONTS
  # Patched by Nerd Font
  font-fira-code-nerd-font
  font-meslo-lg-nerd-font
  font-roboto-mono-nerd-font
  font-sauce-code-pro-nerd-font
)

fonts_to_install=()
for i in ${fonts[@]}; do
  brew list $i &>/dev/null && echo "Font $i already installed!" || fonts_to_install+=($i)
done

if [[ ${fonts_to_install[@]} ]]; then
  brew install "${fonts_to_install[@]}"
else
  echo "All fonts already installed!"
fi

unset casks casks_to_install fonts fonts_to_install
