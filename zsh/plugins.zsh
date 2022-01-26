# =============================================================================
#                                   Plugins
# =============================================================================

# Check if zinit is installed
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f $ZINIT_HOME ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit load lukechilds/zsh-nvm
zinit light romkatv/powerlevel10k

zinit wait lucid for \
  b4b4r07/enhancd \
  OMZP::brew \
  OMZP::colored-man-pages \
  OMZP::node \
  OMZP::npm \
  OMZP::sudo \
  zsh-users/zsh-history-substring-search \
  atinit"zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \

# zplug "plugins/git",        from:oh-my-zsh, if:"which git"
# zplug "plugins/gitfast",    from:oh-my-zsh, if:"which git"
# zplug "plugins/gitignore",  from:oh-my-zsh, if:"which git"
# zplug "plugins/git-extras", from:oh-my-zsh, if:"which git"
# zplug "plugins/git-flow",   from:oh-my-zsh, if:"which gitflow"

# zplug "plugins/ng",         from:oh-my-zsh, if:"which ng"

# =============================================================================
#                              Plugin Settings
# =============================================================================
