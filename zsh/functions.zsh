#!/bin/zsh
autoload colors; colors

# Guard against double-sourcing
if [[ -n ${ZSH_FUNCTIONS_LOADED+x} ]]; then
  return 0
fi
ZSH_FUNCTIONS_LOADED=1

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
  if [[ `ping -c1 8.8.8.8` ]]; then
    echo "$fg[green]You are connected.$reset_color"
    return 0
  else
    echo "$fg[red]Error connecting to the internet!\n$reset_color What century is this!?";
    return 2
  fi
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
  brew update && brew outdated && brew upgrade && brew cleanup
}

function chrome() {
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" $@ & disown
}

function gclone() {
  git clone "$@" || return 1
  local target_dir="${2:-$(basename "$1" .git)}"
  [[ -d "$target_dir" ]] && cd "$target_dir"
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

autoload -U add-zsh-hook
load-volta-nodejs() {
  local NODE_VERSION="lts"

  # Use .nvmrc if it exists
  if [ -f .nvmrc ]; then
    NODE_VERSION=$(cat .nvmrc)
  fi

  # Check if the Node.js version is installed
  if ! volta list node | grep -q "$NODE_VERSION"; then
    if [[ -t 1 ]]; then
      echo "⚡ Installing Node.js $NODE_VERSION with Volta..."
    fi
    volta install node@"$NODE_VERSION"
  fi
}
add-zsh-hook chpwd load-volta-nodejs
load-volta-nodejs

# changes directory to project directory and opens project in vs code
dev() {
  local dir_prefix
  while getopts "o:p:" opt; do
    case $opt in
      o)
        dir_prefix="$HOME/OSTK/SUI/"
        ;;
      p)
        dir_prefix="$HOME/Personal/"
        ;;
      \?)
        echo "Invalid option: -$OPTARG"
        return 1
        ;;
      :)
        echo "Option -$OPTARG requires an argument"
        return 1
        ;;
    esac
  done
  shift "$((OPTIND-1))"

  if [[ -n $OPTARG ]]; then
      cd $dir_prefix$OPTARG || return 1
  fi

  code . || return 1

  return 0
}

# BEGIN_AWS_SSO_CLI

# AWS SSO requires `bashcompinit` which needs to be enabled once and
# only once in your shell.  Hence we do not include the two lines:
#
# autoload -Uz +X compinit && compinit
# autoload -Uz +X bashcompinit && bashcompinit
#
# If you do not already have these lines, you must COPY the lines 
# above, place it OUTSIDE of the BEGIN/END_AWS_SSO_CLI markers
# and of course uncomment it

__aws_sso_profile_complete() {
     local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    _multi_parts : "($(/opt/homebrew/bin/aws-sso ${=_args} list --csv Profile))"
}

aws-sso-profile() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    local _sso=""
    local _profile=""
    
    if [ -n "$AWS_PROFILE" ]; then
        echo "Unable to assume a role while AWS_PROFILE is set"
        return 1
    fi

    # Parse arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -S|--sso)
                shift
                if [ -z "$1" ]; then
                    echo "Error: -S/--sso requires an argument"
                    return 1
                fi
                _sso="$1"
                shift
                ;;
            -*)
                echo "Unknown option: $1"
                echo "Usage: aws-sso-profile [-S|--sso <sso-instance>] <profile>"
                return 1
                ;;
            *)
                if [ -z "$_profile" ]; then
                    _profile="$1"
                else
                    echo "Error: Multiple profiles specified"
                    return 1
                fi
                shift
                ;;
        esac
    done

    if [ -z "$_profile" ]; then
        echo "Usage: aws-sso-profile [-S|--sso <sso-instance>] <profile>"
        return 1
    fi

    # Build and execute the eval command with optional SSO flag
    if [ -n "$_sso" ]; then
        eval $(/opt/homebrew/bin/aws-sso ${=_args} -S "$_sso" eval -p "$_profile")
    else
        eval $(/opt/homebrew/bin/aws-sso ${=_args} eval -p "$_profile")
    fi
    
    if [ "$AWS_SSO_PROFILE" != "$_profile" ]; then
        return 1
    fi
}

aws-sso-clear() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    if [ -z "$AWS_SSO_PROFILE" ]; then
        echo "AWS_SSO_PROFILE is not set"
        return 1
    fi
    eval $(/opt/homebrew/bin/aws-sso ${=_args} eval -c)
}

compdef __aws_sso_profile_complete aws-sso-profile
complete -C /opt/homebrew/bin/aws-sso aws-sso

# END_AWS_SSO_CLI

