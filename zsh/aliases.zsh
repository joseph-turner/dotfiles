# =============================================================================
#                                   Aliases
# =============================================================================

# In the definitions below, you will see use of function definitions instead of
# aliases for some cases. We use this method to avoid expansion of the alias in
# combination with the globalias plugin.

# Directory coloring
export CLICOLOR="YES" # Equivalent to passing -G to ls.
export LSCOLORS="exgxdHdHcxaHaHhBhDeaec"

[ -d "/opt/local/bin" ] && export PATH="/opt/local/bin:$PATH"

# Prefer GNU version, since it respects dircolors.
if which gls &>/dev/null; then
    alias ls='() { $(whence -p gls) -Ctr --file-type --color=auto $@ }'
else
    alias ls='() { $(whence -p ls) -CFtr $@ }'
fi

# Generic command adaptations.
alias grep='() { $(whence -p grep) --color=auto $@ }'
alias egrep='() { $(whence -p egrep) --color=auto $@ }'

# Directory management
alias la='ls -a'
alias ll='ls -l'
alias lal='ls -al'

alias firefox="/Applications/Firefox.app/Contents/MacOS/firefox"
alias ci="code-insiders"

alias hosts="ci"
alias config="ci ${0:a:h}"
alias reload="source ~/.zshrc"

