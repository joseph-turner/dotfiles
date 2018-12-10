# =============================================================================
#                                   Variables
# =============================================================================

export LANG="en_US.UTF-8"
export LC_ALL="$LANG"

# Path to your oh-my-zsh installation.
export ZSH=/Users/joseph.turner/.oh-my-zsh
export NVM_DIR="$HOME/.nvm"

# PATH
# Directories to be prepended to $PATH
# =============================================================================

declare -a dirs_to_prepend
dirs_to_prepend=(
  "/usr/local/sbin"
  "/usr/local"
  "$HOME/bin"
  "$(brew --prefix coreutils)/libexec/gnubin" # Add brew-installed GNU core utilities bin
  "$(brew --prefix)/share/npm/bin" # Add npm-installed package bin
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
  "$ZSH/oh-my-zsh.sh"
  "$(brew --prefix nvm)/nvm.sh"
  "~/.zshrc.local"
  "~/.iterm2_shell_integration.zsh"
)

ZSH_SOURCES_DIR=$(dirname $(readlink $HOME/.zshrc))

# This will grab all of the zsh files in the $DOTFILES_DIR/zsh folder
if [[ $ZSH_SOURCES_DIR ]]; then
  while IFS= read -r -d $'\0'; do
    sources+=("$REPLY")
  done < <(find $ZSH_SOURCES_DIR -name "*.zsh" -print0)
fi

# If the file exists, source it
for i in ${sources[@]}; do
  if [[ -f $i ]]; then
    # echo "sourcing $i"
    source $i
  else
    # echo "$i not found"
  fi
done


# =============================================================================
#                                   Options
# =============================================================================

# improved less option
export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"

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

setopt extended_glob


# =============================================================================
#                                 Completions
# =============================================================================

zstyle ':completion:*' rehash true
#zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*' group-name ''

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

# =============================================================================
#                                   Startup
# =============================================================================

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# History
if zplug check "zsh-users/zsh-history-substring-search"; then
	zmodload zsh/terminfo
	bindkey "$terminfo[kcuu1]" history-substring-search-up
	bindkey "$terminfo[kcud1]" history-substring-search-down
	bindkey "^[[1;5A" history-substring-search-up
	bindkey "^[[1;5B" history-substring-search-down
fi
