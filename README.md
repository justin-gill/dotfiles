# Dotfiles
---
Dotfiles are stored using [GNU Stow](https://www.gnu.org/software/stow/)

## Installation
* Config Install
```
git clone git@github.com:justin-gill/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
stow . --adopt
git restore .
```

* pacman packages
```
pacman -S --needed - < $HOME/.dotfiles/pkglist.txt
```

* Flatpak
```
flatpak install -y $(cat flatpaks.txt)
```

### Misc
* Firewall
```
sudo ufw enable
```
* Various Services
```
sudo systemctl enable bluetooth
sudo systemctl enable sddm.service
sudo systemctl enable tailscaled
sudo systemctl start tailscaled
sudo tailscale set --operator=$USER 
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```
* [Paru Install](https://github.com/Morganamilo/paru)
```
rustup default stable # prereq
```

* [mise](https://mise.jdx.dev/installing-mise.html)
* [tpm](https://github.com/tmux-plugins/tpm) (Use ~/.config/tmux/plugins/tpm)
* [SDDM Sugar Light Theme](https://github.com/MarianArlt/sddm-sugar-light?tab=readme-ov-file#installing-the-theme)
* [Docker post-install](https://docs.docker.com/engine/install/linux-postinstall/)


## Ubuntu
* For minimal Ubuntu, follow these steps
```bash
# Packages
xargs sudo apt-get -y install < $HOME/.dotfiles/apt-pkglist.txt
```

```bash
# Neovim stable ppa is too far behind, unstable to too far ahead
# too lazy to build from source, and this works fine imo
sudo snap install nvim --classic
```

* For Alacritty, you may need to downgrade the config toml file
    * Top level import for theme
    * [terminal.shell] -> [shell]

```bash
sudo update-alternatives --config x-terminal-emulator
```

Ensure Literation Mono font is installed before syncing with dconf
```bash
dconf load / < $HOME/.dotfiles/ubuntu_config.txt
```
