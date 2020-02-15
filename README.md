# TristanHessell/dotfiles

Configuration files for my current environment. This method of tracking configuration comes from many sources, although I have followed along via [here](<https://www.atlassian.com/git/tutorials/dotfiles>).

## Environment Setup

### Get basic set of executables - (maybe) used for setting up the rest of the enviroment.

```bash
  sudo apt install tmux git wget curl
```

### Get this configuration

1. `git clone --bare https://github.com/tristanHessell/dotfiles.git $HOME/.cfg`
2. `git checkout --git-dir=$HOME/.cfg/ --work-tree=$HOME`
3. `source .bashrc`
4. `config config --local status.showUntrackedFiles no`
5. `config update --init --recursive`

### Get all the good executables

```bash
  sudo apt install fzf vim-gtk3 bat curl synapse tidy moc libncurses5-dev libncursesw5-dev xsel cowsay ripgrep jq
```
- tpm: https://github.com/tmux-plugins/tpm#installation
    - make sure to install the tmux plugins too
- nvm: https://classic.yarnpkg.com/en/docs/install#debian-stable
- yarn: https://github.com/nvm-sh/nvm#installing-and-updating
- yarn-autocompletions: https://github.com/dsifford/yarn-completion#installation
- an sql viewer - currently using https://dev.mysql.com/downloads/workbench/ as is most relevant to work

### Install snap executables
- code
- slack
- spotify

### Increase number of file watchers
```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### Change capslock to escape
```bash
  setxkbmap -option caps:escape
```

### Setup shortcuts for Ubuntu MATE UI
```bash
  dconf load .ubuntu-config/mate/marco/.conf /org/mate/marco
```

```bash
  dconf load .ubuntu-config/mate/panel/.conf /org/mate/panel/
```

