# =============================================================================
#                                   Plugins
# =============================================================================

# Check if zplug is installed
[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
#source ~/.zplug/init.zsh && zplug update
source ~/.zplug/init.zsh

zplug "b4b4r07/enhancd", use:init.sh
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

#zplug "plugins/colored-man-pages", from:oh-my-zsh

# zplug "plugins/git",        from:oh-my-zsh, if:"which git"
# zplug "plugins/gitignore",  from:oh-my-zsh, if:"which git"
# zplug "plugins/git-extras", from:oh-my-zsh, if:"which git"
zplug "plugins/git-flow",   from:oh-my-zsh, if:"which gitflow"

# zplug "plugins/ng",         from:oh-my-zsh, if:"which ng"
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
zplug "zsh-users/zsh-history-substring-search",  defer:3, on:"zsh-users/zsh-syntax-highlighting"
