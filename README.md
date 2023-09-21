# Dotfiles
Collection of dotfiles for Arch/Hyprland
--- 
Dotfiles are stored in a bare git repository as outlined [here](https://www.atlassian.com/git/tutorials/dotfiles)

This is a work in progress and will never be completed

## Installation
* pacman packages
```
pacman -S acpi alacritty brightnessctl dunst firefox git grim jq less neofetch neovim network manager nodejs npm openssh pamixer pipewire pythin-dotenv python-pillow python-pip python-pywal qt5 ripgrep rofi-lbon-wayland-git sddm slurp socat sof-firmware tmux vi vim wireplumber xdg-desktop-portal-wlr noto-fonts flatpak
```

* AUR packages
```
paru -S eww-git rofi-lbonn-wayland-git swww wlogout
```

* Flatpak
```
flatpak install md.obsidian.Obsidian
flatpak override --user --env=OBSIDIAN_USE_WAYLAND=1 md.obsidian.Obsidian
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

