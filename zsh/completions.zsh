#!/usr/local/bin/zsh

# =============================================================================
#                                 Completions
# =============================================================================
autoload colors; colors

zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

completions_dir="$(dirname $(readlink $HOME/.zshrc))/completions"
local files=( $completions_dir/* )

for i in ${files[@]}; do
  if [[ -f $i ]]; then
    # echo "Loading $i"
    source $i
  else
    # echo "$i not found"
  fi
done
