# Dotfiles
Collection of dotfiles for [Fedora Sway Spin](https://fedoraproject.org/spins/sway/)
--- 
Dotfiles are stored in a bare git repository as outlined [here](https://www.atlassian.com/git/tutorials/dotfiles)

This is a work in progress and will never be complete

![desktop](https://user-images.githubusercontent.com/47087703/241812078-7c21c335-7229-4bec-b6ce-7afb2ff8e1a8.png)

## Installation

__If you are on a fresh install, update and restart__

### Fedora Essentials
1. Add the following to /etc/dnf/dnf.conf
```
max_parallel_downloads=10
defaultyes=True
```
2. Run this _very safe_ command
```
curl -Ls https://raw.githubusercontent.com/justin-gill/dotfiles/remote_scripts/fedora-sway/install.sh | sudo /bin/bash
```

### Dotfiles
```
curl -Ls https://raw.githubusercontent.com/justin-gill/dotfiles/remote_scripts/fedora-sway/cfg-install.sh | /bin/bash
```
Make sure to reload the config files with mod+shift+c

### Neovim
1. Install packer per [packer.nvim Quickstart](https://github.com/wbthomason/packer.nvim#quickstart)
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
2. Source ~/.config/nvim/lua/any/packer.lua `:so`
    * You are going to see a lot of errors when you first open neovim. Don't fret! Source packer.lua and reload
2. Run PackerSync

