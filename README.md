# Dotfiles
My Dotfiles for Arch/Hyprland
--- 
Dotfiles are stored in a bare git repository as outlined [here](https://www.atlassian.com/git/tutorials/dotfiles)

This is a work in progress and will never be completed

![desktop](https://github.com/justin-gill/dotfiles/assets/47087703/09af07f0-ce29-4118-9f84-37721c68ebe9)


## Installation
* pacman packages
```
pacman -S acpi alacritty brightnessctl dunst firefox git grim jq less neofetch neovim networkmanager nodejs npm openssh pamixer pipewire python-dotenv python-pillow python-pip python-pywal qt5 ripgrep sddm slurp socat sof-firmware tmux vi vim wireplumber xdg-desktop-portal-wlr noto-fonts flatpak python-requests fzf obsidian
```

* AUR packages
```
paru -S eww-git rofi-lbonn-wayland-git swww wlogout nwg-look
```

* Flatpak
```
flatpak install tidal
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
2. Source ~/.config/nvim/lua/any/packer.lua `:so`
    * You are going to see a lot of errors when you first open neovim. Don't fret! Source packer.lua and reload
2. Run PackerSync

