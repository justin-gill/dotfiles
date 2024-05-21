# Dotfiles
My Dotfiles for Arch/Hyprland
---
Dotfiles are stored in a bare git repository as outlined [here](https://www.atlassian.com/git/tutorials/dotfiles)

![desktop](https://github.com/justin-gill/dotfiles/assets/47087703/3999d796-98ae-458f-9dab-ddc0032dd98e)


## Installation
* pacman packages
```
pacman -S acpi alacritty blueman bluez breeze-gtk brightnessctl btop cmake docker docker-compose dunst firefox flatpak fzf git gnome-disk-utility gparted grim hyprlock jq less man-db neovim networkmanager noto-fonts nwg-look openssh pavucontrol polkit-gnome python-dotenv python-pillow python-pip python-pywal qt5 qt5-quickcontrols ripgrep rofi-wayland rustup slurp thunar tmux ttf-liberation-mono-nerd udiskie ufw unzip waybar wl-clipboard
```

* AUR packages ([paru install](https://github.com/Morganamilo/paru?tab=readme-ov-file#installation))
```
rustup default stable
paru -S swww wlogout-git mise
```

* Flatpak
```
flatpak install tidal obsidian cava-git
```

* Config Install
```
git clone --bare git@github.com:justin-gill/dotfiles.git $HOME/.cfg
function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
config config status.showUntrackedFiles no

# sometimes you have to run
config restore .
```

### Neovim
1. Install [nvm](https://github.com/nvm-sh/nvm#install--update-script) (Node is needed for  LSP)
2. Install packer per [packer.nvim Quickstart](https://github.com/wbthomason/packer.nvim#quickstart)
3. Source ~/.config/nvim/lua/any/packer.lua `:so`
    * There will be a lot of errors when neovim is first opened. Don't fret! Source packer.lua and reload
4. Run PackerSync

### tmux
1. Install [tpm](https://github.com/tmux-plugins/tpm)
```
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```
2. prefix + I to install plugins

### Misc
```
ufw enable
```
```
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
```


[Docker post-install](https://docs.docker.com/engine/install/linux-postinstall/)

[SDDM Sugar Light Theme](https://github.com/MarianArlt/sddm-sugar-light?tab=readme-ov-file#installing-the-theme)

