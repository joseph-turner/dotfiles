# =============================================================================
#                                   Plugins
# =============================================================================
autoload colors; colors

# Check if zinit is installed
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
    print -P "$fg[blue]▓▒░ $fg[yellow]Installing $fg[blue]DHARMA $fg[yellow]Initiative Plugin Manager ($fg[blue]zdharma-continuum/zinit$fg[yellow])…$reset_color"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
        print -P "$fg[blue]▓▒░ $fg[green]Installation successful.$reset_color" || \
        print -P "$fg[red]▓▒░ The clone has failed.$reset_color"
fi

source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light romkatv/powerlevel10k

# installs volta then its completions
zinit ice from"gh" pick"volta/volta" atload'volta completions zsh' atclone'volta install' atpull'%atclone' lucid

zinit wait lucid for \
  b4b4r07/enhancd \
  OMZP::brew \
  OMZP::colored-man-pages \
  OMZP::docker \
  OMZP::kubectl \
  OMZP::node \
  OMZP::npm \
  OMZP::sudo \
  zsh-users/zsh-history-substring-search \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
