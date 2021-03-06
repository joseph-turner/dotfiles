#!/bin/env bash

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

ask() {
  print_question "$1"
  read
}

ask_for_confirmation() {
  print_question "$1 (y/n) "
  read -n 1
  printf "\n"
}

ask_for_sudo() {

  # Ask for the administrator password upfront
  sudo -v

  # Update existing `sudo` time stamp until this script has finished
  # https://gist.github.com/cowboy/3118588
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done &> /dev/null &

}

cmd_exists() {
  [ -x "$(command -v "$1")" ] \
    && printf 0 \
    || printf 1
}

execute() {
  $1 &> /dev/null
  print_result $? "${2:-$1}"
}

get_answer() {
  printf "$REPLY"
}

get_os() {

  declare -r OS_NAME="$(uname -s)"
  local os=""

  if [ "$OS_NAME" == "Darwin" ]; then
    os="osx"
  elif [ "$OS_NAME" == "Linux" ] && [ -e "/etc/lsb-release" ]; then
    os="ubuntu"
  fi

  printf "%s" "$os"

}

is_git_repository() {
  [ "$(git rev-parse &>/dev/null; printf $?)" -eq 0 ] \
    && return 0 \
    || return 1
}

mkd() {
  if [ -n "$1" ]; then
    if [ -e "$1" ]; then
      if [ ! -d "$1" ]; then
        print_error "$1 - a file with the same name already exists!"
      else
        print_success "$1"
      fi
    else
      execute "mkdir -p $1" "$1"
    fi
  fi
}

print_error() {
  # Print output in red
  printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_info() {
  # Print output in purple
  printf "\n\e[0;35m $1\e[0m\n\n"
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

backup() {
  # Create dotfiles_old in homedir
  if [ ! -d $dir_backup ]; then
    echo -n "Creating $dir_backup for backup of any existing dotfiles in ~..."
    mkdir -p $dir_backup
    echo "done"
  fi

  # Move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files

  for i in ${FILES_TO_SYMLINK[@]}; do
    echo "Moving any existing dotfiles from ~ to $dir_backup"
    mv ~/${i##*/} $dir_backup
  done
}

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

    'editor/.editorconfig'
    'editor/.eslintrc'

  #   'git/.gitattributes'
    'git/.gitconfig'
    'git/.gitignore'

    'zsh/.zshrc'
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

install_zsh() {
  # Test to see if zshell is installed.  If it is:
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Install Oh My Zsh if it isn't already present
    if [[ ! -d ~/.oh-my-zsh/ ]]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    zsh_path=$(which zsh)
    if [[ ! $(grep "zsh" $SHELL) ]]; then
      # If this zsh is not listed as a standard shell, add it to the list
      grep -q -F "$zsh_path" "/etc/shells" || sudo -v echo "$zsh_path" >> "/etc/shells"
      chsh -s "$zsh_path" && SHELL="$zsh_path"
    fi
  else
    # If zsh isn't installed, get the platform of the current machine
    echo "We'll install zsh, then re-run this script!"
    brew install zsh
    install_zsh
    exit
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
"$DOTFILES_DIR/install/brew.sh"
"$DOTFILES_DIR/install/brew-cask.sh"
"$DOTFILES_DIR/install/node.sh"

symlink_editor_settings
install_zsh

install_wakatime

cd "$CURRENT_DIR"
unset CURRENT_DIR

echo "Sourcing ~/.zshrc"
# Change to zsh to source .zshrc
exec zsh
# Reload zsh settings
source ~/.zshrc

exit
