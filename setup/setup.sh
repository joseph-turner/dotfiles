#!/bin/env zsh

# https://github.com/kaicataldo/dotfiles/blob/master/bin/install.sh

# This symlinks all the dotfiles (and .atom/) to ~/
# It also symlinks ~/bin for easy updating

# This is safe to run multiple times and will prompt you about anything unclear


#
# Utils
#

answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}

ask_for_confirmation() {
  print_question "$1 (y/n) "
  read -n 1
  printf "\n"
}

execute() {
  $1 &> /dev/null
  print_result $? "${2:-$1}"
}

print_error() {
  # Print output in red
  printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_question() {
  # Print output in yellow
  printf "\e[0;33m  [?] $1\e[0m"
}

print_result() {
  [ $1 -eq 0 ] \
    && print_success "$2" \
    || print_error "$2"

  [ "$3" == "true" ] && [ $1 -ne 0 ] \
    && exit
}

print_success() {
  # Print output in green
  printf "\e[0;32m  [✔] $1\e[0m\n"
}

# Warn user this script will overwrite current dotfiles
while true; do
  read -n1 -p "Warning: this will overwrite your current dotfiles. Continue? [y/n]" yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

# Get the dotfiles directory's absolute path
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd -P)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
# Get current dir (to return to it later)
CURRENT_DIR="$(pwd)"

dir_backup=~/dotfiles_old             # old dotfiles backup directory

export DOTFILES_DIR

# Change to the dotfiles directory
echo -n "
Changing to the $DOTFILES_DIR directory..."
cd $DOTFILES_DIR
echo "done"


# =============================================================================
#                           SYMLINK SETUP
# =============================================================================

symlink_files() {

  declare -a FILES_TO_SYMLINK=(
    'git/.gitconfig'
    'git/.gitignore'

    'zsh/.zshrc'
    'zsh/.p10k.zsh'
  )

  local i=''
  local sourceFile=''
  local targetFile=''

  for i in ${FILES_TO_SYMLINK[@]}; do

    sourceFile="$DOTFILES_DIR/$i"
    targetFile="$HOME/$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

    if [ ! -e "$targetFile" ]; then
      execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
    elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
      print_success "$targetFile → $sourceFile"
    else
      ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
      if answer_is_yes; then
        rm -rf "$targetFile"
        execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
      else
        print_error "$targetFile → $sourceFile"
      fi
    fi

  done

  unset FILES_TO_SYMLINK
}

symlink_binaries() {

  # Copy binaries
  ln -fs $DOTFILES_DIR/bin $HOME

  declare -a BINARIES=(
    'ssh-key'
  )

  for i in ${BINARIES[@]}; do
    echo "Changing access permissions for binary script :: ${i##*/}"
    chmod +rwx $HOME/bin/${i##*/}
  done

  unset BINARIES

  declare -a INSTALL_SCRIPTS=(
    'install/brew-cask.sh'
    'install/brew.sh'
    'install/node.sh'

    'setup/macos.sh'
  )

  for i in ${INSTALL_SCRIPTS[@]}; do
    echo "Changing access permissions for install scripts :: $i"
    chmod +rwx $DOTFILES_DIR/$i
  done

}

symlink_editor_settings() {
  # Atom editor settings
  if [[ -d ~/.atom ]]; then
    echo -n "Copying Atom settings.."
    mv -f ~/.atom ~/dotfiles_old/
    ln -s $HOME/dotfiles/atom ~/.atom
    echo "done"
  fi

  # Visual Studio Code - Insiders
  vsci_user_dir="$HOME/Library/Application Support/Code - Insiders/User"
  # cd "$vsci_user_dir"
  if [[ -d "$vsci_user_dir" ]]; then
    echo "VS Code - Insiders: Backing up default user settings"
    [[ -d  "$vsci_user_dir/backups" ]] || mkdir -p "$vsci_user_dir/backups"

    declare -a editor_files=(
      "snippets"
      "keybindings.json"
      "settings.json"
    )

    for i in ${editor_files[@]}; do
      mv -f "$vsci_user_dir/$i" "$vsci_user_dir/backups"
      echo "Linking VS Code - Insiders settings"
      ln -s "$DOTFILES_DIR/editor/vscode/$i" "$vsci_user_dir/$i"
    done
  fi
}

install_wakatime() {
  if [ ! "$(which wakatime)" ]; then
    pip3 install wakatime
  fi
}

# Symlink files and binaries
symlink_files
symlink_binaries

# Package managers & packages
"$DOTFILES_DIR/setup/brew.zsh"
"$DOTFILES_DIR/setup/brew-cask.zsh"
"$DOTFILES_DIR/setup/node.zsh"

symlink_editor_settings

install_wakatime

cd "$CURRENT_DIR"
unset CURRENT_DIR

echo "Sourcing ~/.zshrc"
# Change to zsh to source .zshrc
exec zsh
# Reload zsh settings
source ~/.zshrc

exit
