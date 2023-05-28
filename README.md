# Fedora Sway Spin Dotfiles
Collection of dotfiles for [Fedora Sway Spin](https://fedoraproject.org/spins/sway/)
--- 
Dotfiles are stored in a bare git repository as outlined [here](https://www.atlassian.com/git/tutorials/dotfiles)

This is a work in progress and will never be complete

## Installation

### Fedora Essentials
1. Add the following to /etc/dnf/dnf.conf
```
max_parallel_downloads=10
defaultyes=True
```
1. ./install.sh (run as su)

### Dotfiles
Make sure you don't already have a ~/.cfg directory
1. ./cfg-install.sh

### Neovim
1. Source ~/.config/nvim/lua/any/packer.lua `:so`
1. Run PackerSync

## Resources
[Sway Docs](https://github.com/swaywm/sway/wiki)

## Other dotfiles
[Arch Linux i3](https://github.com/justin-gill/dotfiles/tree/arch-i3)

