# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
#                                   Variables
# =============================================================================
autoload colors; colors

export LANG="en_US.UTF-8"
export LC_ALL="$LANG"
# PATH
# Directories to be prepended to $PATH
# =============================================================================

# Determine ZSH_SOURCES_DIR robustly. If ~/.zshrc is a symlink, resolve it; otherwise
# use the directory that contains the real file. This avoids BSD/macOS readlink portability
# issues when ~/.zshrc is not a symlink.
if [[ -L "$HOME/.zshrc" ]]; then
  ZSH_SOURCES_DIR=$(dirname "$(readlink "$HOME/.zshrc")")
else
  ZSH_SOURCES_DIR=$(dirname "$HOME/.zshrc")
fi

BREW_DIR="/opt/homebrew/bin"
if [[ ! -d $BREW_DIR ]]; then
  if [[ -t 1 ]]; then
    echo "\n$fg[red]Brew directory has changed!$reset_color"
    echo "$fg[blue]Update in $ZSH_SOURCES_DIR/.zshrc\n$reset_color"
  fi
fi

# Directories to prepend to PATH if they exist.
dirs_to_prepend=(
  "/opt/local/bin"
  "/usr/local/sbin"
  "/opt/homebrew/sbin"
  "$BREW_DIR"
  "$HOME/bin"
  "$HOME/bin/git"
  "$HOME/.pyenv/shims"
  "$HOME/.volta/bin"
)

# Explicitly configured $PATH (base)
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

for dir in ${dirs_to_prepend[@]}; do
  if [[ -d ${dir} ]]; then
    # If these directories exist, prepend them to existing PATH
    PATH="${dir}:$PATH"
  fi
done

unset dirs_to_prepend

export PATH
completions_dir="$(dirname "$HOME/.zshrc")/completions"
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
sources=(
  "$HOME/.zshrc.local"
  "$HOME/.iterm2_shell_integration.zsh"
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

# kubectl config settings
if command -v kubectl &> /dev/null; then
  KUBEDIR="$HOME/.kube"
  [[ ! -d $KUBEDIR ]] && mkdir -p $KUBEDIR
  KUBECONFIG=""
  for kubeconfig_file in $KUBEDIR/*(.); do
    KUBECONFIG+=:$kubeconfig_file
  done
  export KUBECONFIG
fi

# improved less option
export LESS="-FiJMRWX -x4 -z-4 --tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"

# Watching other users
#WATCHFMT="%n %a %l from %m at %t."
watch=(notme)         # Report login/logout events for everybody except yourself.
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

compdef _dev dev
compdef _g git
compdef _gatsby gatsby

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Compile frequently-sourced zsh files to .zwc if missing or stale.
# Run in background so shell startup isn't noticably blocked.
compile_dotfiles_zsh_if_needed() {
  command -v zcompile >/dev/null || return 0
  # Only for interactive shells
  [[ $- == *i* ]] || return 0

  ZSH_DIR="$(dirname "$HOME/.zshrc")"
  local files=(functions.zsh aliases.zsh keybindings.zsh plugins.zsh)
  local src zwc needs_compile=0

  for f in "${files[@]}"; do
    src="$ZSH_DIR/$f"
    zwc="$src.zwc"
    [[ -f "$src" ]] || continue
    if [[ ! -f "$zwc" || "$src" -nt "$zwc" ]]; then
      needs_compile=1
      break
    fi
  done

  [[ $needs_compile -eq 1 ]] || return 0

  (
    for f in "${files[@]}"; do
      src="$ZSH_DIR/$f"
      [[ -f "$src" ]] || continue
      zcompile -u "$src" 2>/dev/null || true
    done
  ) & disown
}

# Trigger background compile if needed
compile_dotfiles_zsh_if_needed
