#!/bin/zsh

# =============================================================================
#                                   Functions
# =============================================================================

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$@";
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
  cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

function o() {
  if [ $# -eq 0 ]; then
    open .
  else
    open "$@"
  fi
}

function check_internet() {
  # ping google
  [[ ping -c1 8.8.8.8 ]] && return 0 || return 2
}

# Compare original and gzipped file size
function gz() {
  local origsize=$(wc -c < "$1");
  local gzipsize=$(gzip -c "$1" | wc -c);
  local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
  printf "orig: %d bytes\n" "$origsize";
  printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

function update() {
  echo "Updating and cleaning up homebrew stuff"
  brew update && brew upgrade && brew cleanup

  echo "Installing latest LTS version of Node"
  nvm install --lts && nvm use
}

function chrome() {
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" $@ & disown
}

function gclone() {
  g clone $@
  [[ -n $2 ]] && cd $2 || cd "$(basename $_ .git)"
}

function ip() {
  ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}'
}

function reload() {
  [[ ! $1 ]] && reset && exec zsh

  usage() {
    unset files

    echo
    echo "Reloader - reload sourced files without restarting terminal"
    echo
    echo "usage: reload [-afhkptz]"
    echo
    echo "  reload      Reloads terminal"
    echo "    [-a]      Reloads aliases"
    echo "    [-f]      Reloads functions"
    echo "    [-h]      Displays this message"
    echo "    [-k]      Reloads terminal keybindings"
    echo "    [-p]      Reloads zsh plugins"
    echo "    [-t]      Reloads oh my zsh theme"
    echo "    [-z]      Reloads zshrc file"
  }

  local -a files
  while getopts "acfhkptz" opt; do
    # set arg to file path
    case $opt in
      a)
        files+="aliases"
        ;;
      c)
        files+="completions"
        ;;
      f)
        files+="functions"
        ;;
      h)
        usage
        break;;
      k)
        files+="keybindings"
        ;;
      p)
        files+="plugins"
        ;;
      t)
        files+="theme"
        ;;
      z)
        unset files
        source "$HOME/.zshrc"
        return 0
        ;;
      ?)
        echo "unknown option: -$opt"
        usage
        break;;
    esac
  done
  shift $((OPTIND -1))

  if [[ -n ${files[@]} ]]; then
      ZSH_SOURCES_DIR=$(dirname $(readlink $HOME/.zshrc))
      for i in "${files[@]}"; do
          if [[ -f "$ZSH_SOURCES_DIR/$i.zsh" ]]; then
              echo "reloading $ZSH_SOURCES_DIR/$i.zsh..."
              source "$ZSH_SOURCES_DIR/$i.zsh"
          else
            echo "Couldn't find file"
          fi
      done
  fi
}

y() {
  yarn $@ || nvm use && yarn $@
}
