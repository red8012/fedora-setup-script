# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Fix Python locale issues
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.poetry/bin:$HOME/.cargo/bin:$PATH"

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

mkd() {
    mkdir -pv $1
    cd $1
}

alias l="lsd"
alias ll="lsd -l"
alias lla="lsd -la"
alias nosync="LD_PRELOAD=/usr/lib64/nosync/nosync.so"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
