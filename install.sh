#!/bin/sh
dnf update
# add flatpak
dnf install neovim alacritty git tmux npm gcc gcc-c++ flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# add rpm fusion
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Delete these if you don't want them
# Obsidian
flatpak install flathub md.obsidian.Obsidian
# Tidal
flatpak install flathub com.mastermindzh.tidal-hifi
# Brave
dnf install dnf-plugins-core
dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install brave-browser

# grim dependencies
# some of these may be unneccessary
dnf install meson ninja-build pixman libpng libjpeg cmake cairo-devel wayland-protocols-devel
# grim
git clone --depth 1 https://github.com/emersion/grim.git
cd grim
meson build
ninja -C build
install -m 755 build/grim /usr/local/bin
cd ..
### THE DANGER ZONE ###
rm -rf grim/

