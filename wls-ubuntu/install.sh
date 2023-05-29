# nvim
add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt install neovim tmux gcc g++ -y
# nvm, since default node version on ubuntu conflicts with Mason
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
source ~/.bashrc
nvm install node
