# Fix Python locale issues
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.poetry/bin:$PATH"

ANTIBODY_HOME="$(antibody home)"
export ZSH="$ANTIBODY_HOME"/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh
source ~/.zsh_plugins.sh  # start antibody

eval $(thefuck --alias)
export EDITOR=nano

update_everything() {
    echo "Upgrading system..."
    sudo dnf upgrade
    echo "Setting kernel parameters..."
    sudo grubby --update-kernel=ALL --args="mitigations=off selinux=0 audit=0 noautogroup nowatchdog"
    echo "Upgrading hosts file..."
    wget -O /tmp/hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts
    sudo install -o root --backup=numbered /tmp/hosts /etc/hosts
    rm /tmp/hosts
    echo "Upgrading poetry..."
    poetry self update
}

update_antibody() {
    antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
}

alias l="lsd"
alias ll="lsd -l"
alias lla="lsd -la"
alias nosync="LD_PRELOAD=/usr/lib64/nosync/nosync.so"
