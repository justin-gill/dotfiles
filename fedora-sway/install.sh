#!/bin/sh
dnf update -y
# add flatpak
dnf install neovim alacritty git tmux npm gcc gcc-c++ flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# add rpm fusion
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Delete these if you don't want them
# Obsidian
flatpak install -y --noninteractive flathub md.obsidian.Obsidian
# Tidal
flatpak install -y --noninteractive flathub com.mastermindzh.tidal-hifi
# Brave
dnf install dnf-plugins-core -y
dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install brave-browser -y
