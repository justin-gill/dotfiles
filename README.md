# Dotfiles
---
Dotfiles are stored using [GNU Stow](https://www.gnu.org/software/stow/)

## Installation
* Config Install
```
git clone git@github.com:justin-gill/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
mkdir -p $HOME/.local/bin $HOME/Pictures/{screenshots,wallpapers}
stow . --adopt
git restore .
```

`--adopt` moves any pre-existing files from `$HOME` into the repo before linking;
`git restore .` then discards those adopted copies.

`mkdir -p ~/.local/bin` must run first: stow folds whole directories, so if
`~/.local` doesn't exist yet it becomes a single symlink into the repo and every
app's data under `~/.local` ends up in `~/.dotfiles`. Only the files in
`.local/bin` belong in this package. `~/Pictures` isn't managed by stow; the
`mkdir` just creates the screenshot and wallpaper folders.

After adding or removing files in the repo:
```
stow -R .    # restow (relink changed files)
stow -D .    # unlink everything
```

* pacman packages
```
sudo pacman -S --needed - < $HOME/.dotfiles/pkglist.txt
```

* Flatpak
```
flatpak install -y $(cat flatpaks.txt)
```

### Misc
* Wi-Fi regulatory domain (otherwise falls back to the restrictive "world" domain)
```
sudoedit /etc/conf.d/wireless-regdom    # uncomment WIRELESS_REGDOM="US"
```

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
sudo systemctl enable docker.socket                # start docker on first use instead of blocking boot on network-online
sudo systemctl enable --now paccache.timer         # weekly: keep last 3 versions in pacman cache
sudo systemctl enable --now systemd-oomd           # kill runaway processes before the desktop freezes
sudo systemctl enable --now power-profiles-daemon  # power profiles (Noctalia battery widget)
sudo systemctl enable --now reflector.timer        # weekly mirrorlist refresh (/etc/xdg/reflector/reflector.conf)
```

* Firmware updates
```
fwupdmgr refresh && fwupdmgr update
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

* Noctalia Plugins (run with noctalia running)
```bash
noctalia msg plugins enable davemhammer/tailscale
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

* Set the default terminal
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
