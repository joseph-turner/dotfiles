# =============================================================================
#                                Key Bindings
# =============================================================================

# Do not require a space when attempting to tab-complete.
bindkey "^i" expand-or-complete-prefix

# Delete forward
bindkey '^[[3~' delete-char

# Skip forward/back a word with opt-arrow
bindkey '[C' forward-word
bindkey '[D' backward-word

# Skip to start/end of line with cmd-arrow
bindkey '^[A' beginning-of-line
bindkey '^[E' end-of-line

# Delete word with opt-backspace/opt-delete
bindkey '[G' backward-kill-word
bindkey '[H' kill-word

# Delete line with cmd-backspace/cmd-delete
bindkey '[I' backward-kill-line
bindkey '^[I' backward-kill-line
bindkey '^[K' kill-line

# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^h' _complete_help
