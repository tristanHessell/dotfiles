  git log \
    --graph --color=always --abbrev=7 --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" $@ | \
    fzf \
      --ansi --no-sort --reverse --tiebreak=index \
      --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always \$1 -- $@; }; f {}" \
      --bind=ctrl-d:preview-page-down \
      --bind=ctrl-u:preview-page-up \
      --bind="enter:execute:
          (grep -o '[a-f0-9]\{7\}' | head -1 |
          xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
          {}
FZF-EOF" # this spacing here is important: so 18660798

# TODO
# toggle preview
# copy commit
# enter takes you to vim diff

