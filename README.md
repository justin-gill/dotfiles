# Dotfiles
---
Dotfiles are stored using [GNU Stow](https://www.gnu.org/software/stow/)

## Installation
* Config Install
```
git clone git@github.com:justin-gill/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
stow . --adopt
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
sudo tailscale set --operator=$USER 
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```
* [Paru Install](https://github.com/Morganamilo/paru)
```
rustup default stable # prereq
```

* [mise](https://mise.jdx.dev/installing-mise.html)
* [tpm](https://github.com/tmux-plugins/tpm)
* [SDDM Sugar Light Theme](https://github.com/MarianArlt/sddm-sugar-light?tab=readme-ov-file#installing-the-theme)
* [Docker post-install](https://docs.docker.com/engine/install/linux-postinstall/)

