
# update
sudo apt -y update

# install vim
sudo apt -y install vim

# Remove snapd
sudo snap remove --purge firefox
sudo snap remove --purge snap-store
sudo snap remove --purge snapd-desktop-integration
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge gnome-3-38-2004
sudo snap remove --purge core20
sudo snap remove --purge bare
sudo snap remove --purge snapd
sudo apt remove -y --purge snapd
sudo apt-mark hold snapd # avoid install snapd again

# Add firefox ppa
sudo add-apt-repository ppa:mozillateam/ppa

# set ppa priority over snap
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

sudo apt -y install firefox

sudo apt -y install grub-customizer
sudo apt -y install deja-dup
sudo apt -y install kwin-bismuth

# vscode
sudo apt-get -y install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt -y install apt-transport-https
sudo apt update
sudo apt -y install code

# Docker apt
sudo apt-get update
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Docker permissions
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

sudo apt install -y docker-compose

#npm
sudo apt -y install npm

# node and n for node version (could use nvm but no need)
sudo apt -y install nodejs
sudo npm cache clean -f
sudo npm install -g n
sudo n stable

# joplin
NPM_CONFIG_PREFIX=~/.joplin-bin npm install -g joplin
sudo ln -s ~/.joplin-bin/bin/joplin /usr/bin/joplin

# git config
git config --global user.name "justin-gill"
git config --global user.email gill.justin1999@gmail.com

## MANUAL

ssh-keygen -t ed25519 -C "gill.justin1999@gmail.com"
ssh-add ~/.ssh/id_ed25519 

mkdir -p ~/repos/ && cd ~/repos/
git clone git@github.com:justin-gill/dotfiles.git
cp dotfiles/.vimrc ~/.
