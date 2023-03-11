# Dotfiles
---

install i3-wm

```
sudo pacman -S i3-wm ttf-dejavu i3status
```

Need xinit for display server
```
sudo pacman -S xorg xorg-xinit xterm
```
```
cp /etc/X11/xinit/xinitrc ~/.xinitrc
```

```
sudo pacman -S nvidia nvidia-utils # NVIDIA
sudo pacman -S xf86-video-amdgpu mesa # AMD
sudo pacman -S xf86-video-intel mesa # Intel
sudo pacman -S virtualbox-guest-iso # if vbox
```
```
pacman -S alsa-utils
```

Display Manager
```
sudo pacman -S lightdm lightdm-slick-greeter
systemctl enable lightdm
```
/etc/lightdm/lightdm.conf
```
greeter-session=lightdm-slick-greeter
```


Polybar
follow docs
```
sudo pacman -S polybar
cp /etc/polybar/config.ini ~/.config/polybar/config.ini
~/.config/polybar/launch.sh
```

Rofi
https://github.com/davatorium/rofi#installation
```
sudo pacman -S rofi
```
