
if hash rg 2>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
  export FZF_CTRL_T_COMMAND='rg --files --hidden --follow'
  export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi

export FZF_DEFAULT_OPTS='--color=hl:#ff0000,hl+:#ff0000'

# fe [FUZZY_PATTERN] - Open the selected file in default editor
fe () {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fif <SEARCH_TERM>  Find-in-file and open in editor 
fif () {
  if [ ! "$#" -gt 0 ]; then echo "Need string to search for"; return 1; fi

  local files
  IFS=$'\n'
  files=($(rg --files-with-matches --no-messages --hidden --sort path --follow "$1" | fzf --preview-window=right:50%:wrap --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
  
}

# automatically added by git-installed fzf install script
# used only if cant download fzf through apt
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

