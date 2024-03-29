# =============================================================================
#                                   Aliases
# =============================================================================

# In the definitions below, you will see use of function definitions instead of
# aliases for some cases. We use this method to avoid expansion of the alias in
# combination with the globalias plugin.

# Directory coloring
export CLICOLOR="YES" # Equivalent to passing -G to ls.
export LSCOLORS="exgxdHdHcxaHaHhBhDeaec"

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
alias lsa='ls -a'
alias lsl='ls -l'
alias lsal='ls -al'

alias firefox="/Applications/Firefox.app/Contents/MacOS/firefox"
! type code &> /dev/null && type code-insiders &> /dev/null && alias code="code-insiders"
alias c.="code -n ."
alias ci="code -n"
alias ci.="c."

alias config="code $(dirname ${0:a:h})"

alias y="yarn"
alias yd="y dev"
alias ydi="y dev:inspect"
alias yf="y flow"
alias yl="y lint"
alias ylj="y lint:js"
alias ylc="y lint:css"
alias ytf="yt && yf"
alias ytw="y test:watch"
alias yst="y && y start"
alias yt="y test"
alias yti="y test:integration"
alias ytw="y test:watch"
# yarn charles => yarn chuck => yuck
alias yuck="y charles"
alias gyst="gmm && yst"

# My most common git commands
alias g="git"
alias gcm="g cm"
alias gcmp="g cmp"
alias gco="g co"
alias gcob="g cob"
alias gf="git-flow"
alias gmm="g mm"
alias gmt="g mt"
alias gpu="g pu"
alias gst="g st"
alias gup="g up"
alias gust="g up && yst"
