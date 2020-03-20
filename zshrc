# Fix Python locale issues
export LC_ALL=en_US.UTF-8

ANTIBODY_HOME="$(antibody home)"
export ZSH="$ANTIBODY_HOME"/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh
source ~/.zsh_plugins.sh  # start antibody
eval $(thefuck --alias)

update_antibody() {
    antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
}
