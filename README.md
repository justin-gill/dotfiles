# Dotfiles
Collection of dotfiles for Arch/Hyprland
--- 
Dotfiles are stored in a bare git repository as outlined [here](https://www.atlassian.com/git/tutorials/dotfiles)

This is a work in progress and will never be completed

### Neovim
1. Install packer per [packer.nvim Quickstart](https://github.com/wbthomason/packer.nvim#quickstart)
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
2. Source ~/.config/nvim/lua/any/packer.lua `:so`
    * You are going to see a lot of errors when you first open neovim. Don't fret! Source packer.lua and reload
2. Run PackerSync

