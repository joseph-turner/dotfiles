#!/bin/sh

#
# This script configures my Node.js development setup. Note that
# nvm is installed by the Homebrew install script.
#
# Also, I would highly reccomend not installing your Node.js build
# tools, e.g., Grunt, gulp, WebPack, or whatever you use, globally.
# Instead, install these as local devDepdencies on a project-by-project
# basis. Most Node CLIs can be run locally by using the executable file in
# "./node_modules/.bin". For example:
#
#     ./node_modules/.bin/webpack --config webpack.local.config.js
#

if [[ -d "$HOME/.nvm" && -f "/usr/local/opt/nvm/nvm.sh" ]]; then
  source "/usr/local/opt/nvm/nvm.sh"
  echo "Installing the most recent LTS version of Node..."

  # Install the latest stable version of node
  nvm install --lts

  # Switch to the installed version
  nvm use node

  # Use the stable version of node by default
  nvm alias default "lts/*"

else
  echo "NVM not installed. Run `brew.sh` or `brew install nvm`"
fi

# All `npm install <pkg>` commands will pin to the version that was available at the time you run the command
npm config set save-exact = true

# Globally install with npm
# To list globally installed npm packages and version: npm list -g --depth=0
#
# Some descriptions:
#
# diff-so-fancy — sexy git diffs
# git-recent — Type `git recent` to see your recent local git branches
# git-open — Type `git open` to open the GitHub page or website for a repository

packages=()

if [[ ${packages[@]} ]]; then
  printf "Installing global NPM packages:%s\n" "${packages[@]}"
  packages_to_install=()
  for i in ${packages[@]}; do
    npm ls -g "$i" &> /dev/null && echo "Package $i already installed!" || packages_to_install+=($i)
  done

  if [[ ${packages_to_install[@]} ]]; then
    npm install -g "${packages_to_install[@]}"
  else
    echo "All Node packages already installed!"
  fi
else
  echo "No packages listed for installation."
  npm ls -gp --depth=0 | awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}' | xargs npm -g rm
fi
