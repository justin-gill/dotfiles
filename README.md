# Dotfiles
Collection of dotfiles for [Arch with i3](https://archlinux.org/)
--- 
Dotfiles are stored in a bare git repository as outlined [here](https://www.atlassian.com/git/tutorials/dotfiles)

This is a work in progress and will never be complete

![desktop](https://user-images.githubusercontent.com/47087703/224602442-b6cfb0fa-1968-488d-b263-1aabc64d30b6.png)

## Installation

### Arch Essentials
1. Run this _very safe_ command
```
curl -Ls https://raw.githubusercontent.com/justin-gill/dotfiles/remote_scripts/arch-i3/install.sh | sudo /bin/bash
```

### Dotfiles
```
curl -Ls https://raw.githubusercontent.com/justin-gill/dotfiles/remote_scripts/arch-i3/cfg-install.sh | /bin/bash
```

### Neovim
1. Install packer per [packer.nvim Quickstart](https://github.com/wbthomason/packer.nvim#quickstart)
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
2. Source ~/.config/nvim/lua/any/packer.lua `:so`
    * You are going to see a lot of errors when you first open neovim. Don't fret! Source packer.lua and reload
2. Run PackerSync

