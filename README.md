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

`--adopt` moves any pre-existing files from `$HOME` into the repo before linking;
`git restore .` then discards those adopted copies. Do not run it against a
populated `~/.local`: stow folds whole directories, and only `.local/bin` belongs
in this package.

After adding or removing files in the repo:
```
stow -R .    # restow (relink changed files)
stow -D .    # unlink everything
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
* [Docker post-install](https://docs.docker.com/engine/install/linux-postinstall/)

* Local, untracked overrides
```
$EDITOR ~/.config/git/config.local       # per-machine overrides, e.g. [user] name/email (git-ignored)
```

* [Noctalia Greeter](https://docs.noctalia.dev/greeter/installation/)
```bash
paru -S noctalia-greeter
```

## Ubuntu
* For minimal Ubuntu, follow these steps
```bash
# Packages
xargs sudo apt-get -y install < $HOME/.dotfiles/apt-pkglist.txt
```

Ghostty is only in the Ubuntu archive from 26.04 onward; on older releases add the
[community PPA](https://github.com/mkasberg/ghostty-ubuntu) first:
```bash
sudo add-apt-repository ppa:mkasberg/ghostty-ubuntu
sudo apt update && sudo apt install ghostty
```

```bash
# Neovim stable ppa is too far behind, unstable to too far ahead
# too lazy to build from source, and this works fine imo
sudo snap install nvim --classic

# Go isn't necessary, but it is enabled by default in Neovim LSP conf
# Mason-lspconfig will complain if go is not installed
sudo snap install --classic go
# in a similar vein
mise install # for global node (also prereq for some lsps)
```

* For Alacritty, you may need to downgrade the config toml file
    * Top level import for theme
    * [terminal.shell] -> [shell]

```bash
sudo update-alternatives --config x-terminal-emulator
```

Ensure Literation Mono font is installed before syncing with dconf
```bash
dconf load / < $HOME/.dotfiles/ubuntu-config.txt
```

Audio Effect Support (for lack of noise cancellation in chromium based apps)
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.github.wwmm.easyeffects
```
