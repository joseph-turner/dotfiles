# =============================================================================
#                                   Variables
# =============================================================================
autoload colors; colors

export LANG="en_US.UTF-8"
export LC_ALL="$LANG"

export NVM_DIR="$HOME/.nvm"
export NVM_DEFAULT="lts/*"

# PATH
# Directories to be prepended to $PATH
# =============================================================================

ZSH_SOURCES_DIR=$(dirname $(readlink $HOME/.zshrc))

local BREW_DIR="/usr/local"
if [[ ! -d "/usr/local" ]]; then
  echo "\n$fg[red]Brew directory has changed!"
  echo "Update in $ZSH_SOURCES_DIR/.zshrc\n"
fi

local -a dirs_to_prepend
dirs_to_prepend=(
  "/opt/local/bin"
  "/usr/local/sbin"
  "$BREW_DIR"
  "$HOME/bin"
  "$HOME/bin/git"
  # "$(brew --prefix coreutils)/libexec/gnubin" # Add brew-installed GNU core utilities bin
  # "$(brew --prefix)/share/npm/bin" # Add npm-installed package bin
)

# Explicitly configured $PATH
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

for dir in ${(k)dirs_to_prepend[@]}; do
  if [ -d ${dir} ]; then
    # If these directories exist, then prepend them to existing PATH
    PATH="${dir}:$PATH"
  fi
done

unset dirs_to_prepend

export PATH
completions_dir="$(dirname $(readlink $HOME/.zshrc))/completions"
fpath=($completions_dir ~/bin "${fpath[@]}" )

export GIT_FRIENDLY_NO_BUNDLE=true
# export GIT_FRIENDLY_NO_NPM=true
export GIT_FRIENDLY_NO_YARN=true
export GIT_FRIENDLY_NO_BOWER=true
export GIT_FRIENDLY_NO_COMPOSER=true


# =============================================================================
#                                   Sources
# =============================================================================

# List of files that need to be sourced outside of the dotfiles dir
local sources=(
  "$HOME/.zshrc.local"
  "$HOME/.iterm2_shell_integration.zsh"
  "$HOME/bin/lazy-load-node"
)

# This will grab all of the zsh files in the $DOTFILES_DIR/zsh folder
if [[ $ZSH_SOURCES_DIR ]]; then
  while IFS= read -r -d $'\0'; do
    sources+=("$REPLY")
  done < <(find $ZSH_SOURCES_DIR -name "*.zsh" -print0)
fi

# If the file exists, source it
for i in ${sources[@]}; do
  if [[ -f $i ]]; then
    # echo "Loading $i"
    source $i
  # else
  #   echo "$i not found"
  fi
done

# =============================================================================
#                                   Options
# =============================================================================

# improved less option
export LESS="-FiJMRWX -x4 -z-4 --tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"

# Watching other users
#WATCHFMT="%n %a %l from %m at %t."
watch=(notme)         # Report login/logout events for everybody except ourself.
LOGCHECK=60           # Time (seconds) between checks for login/logout activity.
REPORTTIME=5          # Display usage statistics for commands running > 5 sec.
WORDCHARS="\"*?_-[]~&;!#$%^(){}<>\""

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.

# Changing directories
#setopt auto_pushd
setopt pushd_ignore_dups        # Dont push copies of the same dir on stack.
setopt pushd_minus              # Reference stack entries with "-".
setopt promptsubst

setopt extended_glob

# TODO: add custom completions leveraging _git
compdef _g git
compdef _gatsby gatsby
