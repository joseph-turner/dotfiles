# custom git shortcuts
function _git2() {
  _git "$@"
  local state ret=1
  local -a subcmds
  subcmds=(
    'bclean:clean local repo'
    'co:checkout new branch or recent branch'
    'mm:merge latest changes from master into current branch'
    'pu:push changes from current branch, set upstream if new branch'
    'up:pull latest changes and check for yarn.lock changes/update packages'
  )
  # # _describe 'command' subcmds
  _arguments -C '1: :->cmds' '*: :->args' && ret=0

  __git_branches() {
    echo "$(git branch)"
  }

  __git_recent() {
    echo "$(git recent -l)"
  }

  case $state in
    cmds)
      _describe -t commands 'g commands' subcmds && ret=0
      ;;
    args)
      case $words[2] in
        (co)
          _values 'branches' $(__git_branches) && ret=0
          ;;

        (cor)
          _values 'recent branches' $(__git_recent) && ret=0
          ;;

        *)
          (( ret )) && _message 'no more arguments'
          ;;
      esac
      ;;
    *)
      (( ret )) && _message 'no more commands'
  esac

  return ret
}
