# source https://www.atlassian.com/git/tutorials/dotfiles
# https://web.archive.org/web/20230526182753/https://www.atlassian.com/git/tutorials/dotfiles
git clone --bare git@github.com:justin-gill/dotfiles.git $HOME/.cfg
function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
config checkout -f sway-fedora
config config status.showUntrackedFiles no
