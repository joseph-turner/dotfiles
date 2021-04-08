# =============================================================================
#                                   Plugins
# =============================================================================

# Check if zplug is installed
[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh

zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "b4b4r07/enhancd", use:init.sh
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
# zplug "sobolevn/wakatime-zsh-plugin", use:wakatime.plugin.zsh

# zplug "plugins/git",        from:oh-my-zsh, if:"which git"
# zplug "plugins/gitfast",    from:oh-my-zsh, if:"which git"
# zplug "plugins/gitignore",  from:oh-my-zsh, if:"which git"
# zplug "plugins/git-extras", from:oh-my-zsh, if:"which git"
# zplug "plugins/git-flow",   from:oh-my-zsh, if:"which gitflow"

# zplug "plugins/ng",         from:oh-my-zsh, if:"which ng"
zplug "plugins/nvm",        from:oh-my-zsh, if:"which nvm"
zplug "plugins/node",       from:oh-my-zsh, if:"which node"
zplug "plugins/npm",        from:oh-my-zsh, if:"which npm"
zplug "plugins/yarn",       from:oh-my-zsh, if:"which yarn"

zplug "plugins/sudo",       from:oh-my-zsh, if:"which sudo"

if [[ $OSTYPE = (darwin)* ]]; then
    zplug "plugins/osx",      from:oh-my-zsh
    zplug "plugins/brew",     from:oh-my-zsh, if:"which brew"
fi

zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"


# =============================================================================
#                              Plugin Settings
# =============================================================================



# =============================================================================
#                                 Startup
# =============================================================================

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# History
if zplug check "zsh-users/zsh-history-substring-search"; then
  zmodload zsh/terminfo
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
  bindkey "^[[1;5A" history-substring-search-up
  bindkey "^[[1;5B" history-substring-search-down
fi
