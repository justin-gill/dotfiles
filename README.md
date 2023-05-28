# Dotfiles
Collection of dotfiles for [Fedora Sway Spin](https://fedoraproject.org/spins/sway/)
--- 
Dotfiles are stored in a bare git repository as outlined [here](https://www.atlassian.com/git/tutorials/dotfiles)

This is a work in progress and will never be complete

![desktop](https://github.com/justin-gill/dotfiles/assets/47087703/c48ceeab-78f5-43d5-a6de-bf18ff0f130b)

## Installation

__If you are on a fresh install, update and restart__

### Fedora Essentials
1. Add the following to /etc/dnf/dnf.conf
```
max_parallel_downloads=10
defaultyes=True
```
1. Run this _very safe_ command
```
curl -Ls https://raw.githubusercontent.com/justin-gill/dotfiles/remote_scripts/fedora-sway/install.sh | sudo /bin/bash
```
1. Configure git ([SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent))
```
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
git config --global user.email "your_email@example.com"
git config --global user.name "Your Name"
git config --global --add --bool push.autoSetupRemote true
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
1. Source ~/.config/nvim/lua/any/packer.lua `:so`
    * You are going to see a lot of errors when you first open neovim. Don't fret! Source packer.lua and reload
1. Run PackerSync

## Resources
[Sway Docs](https://github.com/swaywm/sway/wiki)

## Other dotfiles
[Arch Linux i3](https://github.com/justin-gill/dotfiles/tree/arch-i3)

