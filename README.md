# TristanHessell/dotfiles

Configuration files for my current environment.

This method of tracking configuration comes from many sources, although I have
followed along via [here](<https://www.atlassian.com/git/tutorials/dotfiles>).

## Environment Setup

### Get basic set of executables

```bash
  sudo apt install tmux git wget curl
```

### Get this configuration

1. `git clone --bare https://github.com/tristanHessell/dotfiles.git $HOME/.cfg`
2. `git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout`
3. `source .bashrc`
4. `config config --local status.showUntrackedFiles no`
5. `config submodule update --init --recursive`

### Get vim

Vim from the PPA has been updated regularly

```bash
sudo add-apt-repository ppa:jonathonf/vim
sudo apt-get update
```

### Get all the good executables

```bash
  sudo apt install fzf bat curl synapse tidy moc libncurses5-dev libncursesw5-dev 
  xsel cowsay ripgrep jq acpi vifm tree fortunes gimp pmount
```

- tpm: https://github.com/tmux-plugins/tpm#installation
    - make sure to install the tmux plugins too
- yarn: https://classic.yarnpkg.com/en/docs/install#debian-stable
- nvm: https://github.com/nvm-sh/nvm#installing-and-updating
- yarn-autocompletions: https://github.com/dsifford/yarn-completion#installation
- an sql viewer - currently using https://dev.mysql.com/downloads/workbench/

### Install snap executables

- code
- slack
- spotify
- universal-ctags (ubuntu 18.X)

### Increase number of file watchers

```bash
  echo fs.inotify.max_user_watches=524288 | \
  sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### Setup shortcuts for Ubuntu MATE UI

```bash
  loadshortcuts
```

#### To update the .conf files

```bash
  saveshortcuts
```

### Update the git submodule'd directories

Currently this is only for vim plugins

```bash
  config submodule update --recursive --merge
```

## Known issues:

### vi

- https://github.com/junegunn/fzf.vim/issues/510 (non fatal)

### tmux

- error message on first load of tmux (non fatal)

