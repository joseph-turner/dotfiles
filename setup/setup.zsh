#!/bin/zsh
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
  read -qs "?$(print_question "$1 (y/n) ")"
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

  # [ "$3" == "true" ] && [ $1 -ne 0 ] \
  #   && exit
}

print_success() {
  # Print output in green
  printf "\e[0;32m  [✔] $1\e[0m\n"
}

# Warn user this script will overwrite current dotfiles
while true; do
  echo $fg[red]WARNING: this will overwrite your current dotfiles.$reset_color
  read -qs "?Continue? [y/n]" yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "\nPlease answer yes or no.";;
  esac
done

# Get the dotfiles directory's absolute path
SCRIPT_DIR="${0:a:h}"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
# Get current dir (to return to it later)
CURRENT_DIR="$(pwd)"

echo $SCRIPT_DIR
echo $DOTFILES_DIR
echo $CURRENT_DIR

export DOTFILES_DIR

# Change to the dotfiles directory
echo -n "\nChanging to the $DOTFILES_DIR directory..."
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

  for i in ${FILES_TO_SYMLINK[@]}; do

    sourceFile="$DOTFILES_DIR/$i"
    targetFile="$HOME/$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

    if [[ ! -e $targetFile ]]; then
      ln -fs $sourceFile $targetFile
    elif [[ $(readlink "$targetFile") == $sourceFile ]]; then
      print_success "$targetFile → $sourceFile"
    else
      ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
      if answer_is_yes; then
        rm -rf "$targetFile"
        ln -fs $sourceFile $targetFile
      else
        print_error "$targetFile → $sourceFile"
      fi
    fi

  done

  unset FILES_TO_SYMLINK
}

symlink_binaries() {

  # Copy binaries
  ln -fs $DOTFILES_DIR/git/bin $DOTFILES_DIR/bin/git
  ln -fs $DOTFILES_DIR/bin $HOME

  declare -a BINARIES=(
    'bounce'
    'kbsh'
    'kbt'
    'setperm'
    'ssh-key'
  )

  for i in ${BINARIES[@]}; do
    echo "Changing access permissions for binary script :: ${i##*/}"
    chmod +rwx $HOME/bin/${i##*/}
  done

  unset BINARIES
}

# Symlink files and binaries
symlink_files
symlink_binaries

ask_for_confirmation "Run MacOS Script?"
if answer_is_yes; then
  chmod +rwx $SCRIPT_DIR/macos.zsh
  $SCRIPT_DIR/macos.zsh
fi

# Package managers & packages
ask_for_confirmation "Run Homebrew Script?"
if answer_is_yes; then
  chmod +rwx $SCRIPT_DIR/brew.zsh
  $SCRIPT_DIR/brew.zsh

  # iterm2 shell integration
  curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
fi

ask_for_confirmation "Run Homebrew Cask Script?"
if answer_is_yes; then
  chmod +rwx $SCRIPT_DIR/brew-cask.zsh
  $SCRIPT_DIR/brew-cask.zsh
fi

ask_for_confirmation "Run Node Script?"
if answer_is_yes; then
  chmod +rwx $SCRIPT_DIR/node.zsh
  $SCRIPT_DIR/node.zsh
fi

cd "$CURRENT_DIR"
unset CURRENT_DIR

reset && exec zsh

exit
