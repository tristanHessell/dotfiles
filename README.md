# TristanHessell/dotfiles

Configuration files for my current environment. This method of tracking configuration comes from many sources, although I have followed along via [here](<https://www.atlassian.com/git/tutorials/dotfiles>).

## Environment Setup

1. `git clone --bare <git-repo-url> $HOME/.cfg`
2. `git checkout config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`
3. `source .bashrc`
4. `config config --local status.showUntrackedFiles no`
