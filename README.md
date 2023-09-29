# Dotfiles
Collection of dotfiles for Arch/Hyprland
--- 
Dotfiles are stored in a bare git repository as outlined [here](https://www.atlassian.com/git/tutorials/dotfiles)

This is a work in progress and will never be completed

## Installation
* pacman packages
```
pacman -S acpi alacritty brightnessctl dunst firefox git grim jq less neofetch neovim networkmanager nodejs npm openssh pamixer pipewire python-dotenv python-pillow python-pip python-pywal qt5 ripgrep sddm slurp socat sof-firmware tmux vi vim wireplumber xdg-desktop-portal-wlr noto-fonts flatpak python-requests
```

* AUR packages
```
paru -S eww-git rofi-lbonn-wayland-git swww wlogout nwg-look
```

* Flatpak
```
flatpak install md.obsidian.Obsidian
flatpak override --user --env=OBSIDIAN_USE_WAYLAND=1 md.obsidian.Obsidian
```

* Config Install
```
git clone --bare git@github.com:justin-gill/dotfiles.git $HOME/.cfg
function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
config checkout -f arch-hyprland
config config status.showUntrackedFiles no
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

