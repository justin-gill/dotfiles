# Ubuntu
Minimal setup for Ubuntu. Clone as in the [README](README.md), install packages, then run the README's Config Install step.

* Packages
```
xargs sudo apt-get -y install < $HOME/.dotfiles/apt-pkglist.txt
```

* Ghostty is only in the Ubuntu archive from 26.04 onward; on older releases add the
[community PPA](https://github.com/mkasberg/ghostty-ubuntu) first
```
sudo add-apt-repository ppa:mkasberg/ghostty-ubuntu
sudo apt update && sudo apt install ghostty
```

* Neovim (the stable PPA is too far behind, unstable too far ahead)
```
sudo snap install nvim --classic
```

* [mise](https://mise.jdx.dev/installing-mise.html), then install global tools (node, go, uv, shellcheck)
```
mise install
```

* tree-sitter CLI, needed by Neovim to install parsers
```
npm install -g tree-sitter-cli
```

* Set the default terminal
```
sudo update-alternatives --config x-terminal-emulator
```

* LiterationMono Nerd Font (not packaged in apt), then load the dconf settings that use it
```
curl -fLo /tmp/LiberationMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/LiberationMono.zip
mkdir -p $HOME/.local/share/fonts/LiberationMono
unzip -o /tmp/LiberationMono.zip -d $HOME/.local/share/fonts/LiberationMono
fc-cache -f
dconf load / < $HOME/.dotfiles/ubuntu-config.txt
```
