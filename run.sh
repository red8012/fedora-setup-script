#!/bin/bash

# strict mode
set -euo pipefail
IFS=$'\n\t'

read -p "Turn off unused search settings [Enter]"
read -p "Turn off automatic update in Gnome Software [Enter]"

read -p "Install Dash to Dock and Bing Wallpaper Changer [Enter]"
firefox http://extensions.gnome.org

read -p "Set Firefox homepage [Enter]"
read -p "Install AdBlock [Enter]"
firefox "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"

read -p "Upgrade system [Enter]"
sudo dnf upgrade

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

read -p "Enable RPM Fusion [Enter]"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

read -p "Install software [Enter]"
sudo dnf install nodejs yarnpkg zsh bat fzf grubby gnome-tweaks lsd youtube-dl zopfli aria2 tldr dconf-editor lollypop filezilla gitg audacity seahorse code transmission make nosync thefuck util-linux-user nano meld

read -p "Install non-free codecs [Enter]"
sudo dnf install gstreamer1-libav gstreamer1-plugins-good-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-free-extras
sudo dnf install lame lame-mp3x
sudo dnf group upgrade --with-optional Multimedia

read -p "Install Google Chrome [Enter]"
firefox https://google.com/chrome

read -p "Set keyboard.dispatch in VSCode to keyCode"

read -p "Set kernel parameters [Enter]"
sudo grubby --update-kernel=ALL --args="mitigations=off selinux=0 audit=0 noautogroup nowatchdog"

read -p "Terminal -> Preferences -> Profile -> Commands -> check both, input zsh [Enter]" 
read -p "Install MesloLGS Nerd Fonts [Enter]"
pushd /usr/share/fonts
sudo mkdir -p meslo-lgs-nerd
pushd meslo-lgs-nerd
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
popd
popd
fc-cache -v

read -p "Set up Antibody (may take a minute) [Enter]"
curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
cp zshrc $HOME/.zshrc
cp zsh_plugins.txt $HOME/.zsh_plugins.txt
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
read -p "Please configure Powerline10k (don't forget to exit when you're done) [Enter]"
zsh
sudo chsh -s /usr/bin/zsh $USER

read -p "Set hosts file [Enter]"
wget -O /tmp/hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts
sudo install -o root --backup=numbered /tmp/hosts /etc/hosts
rm /tmp/hosts

read -p "Set sysctl.conf [Enter]"
echo "vm.swappiness = 1" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_background_bytes = 16777216" | sudo tee -a /etc/sysctl.conf
echo "kernel.sched_latency_ns = 3000000" | sudo tee -a /etc/sysctl.conf # 1/4
echo "kernel.sched_min_granularity_ns = 300000" | sudo tee -a /etc/sysctl.conf # 1/5
echo "kernel.sched_wakeup_granularity_ns = 500000" | sudo tee -a /etc/sysctl.conf # 1/4
bat /etc/sysctl.conf

read -p "Install Poetry [Enter]"
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

read -p "Generate SSH key [Enter]"
ssh-keygen -t rsa -C "red8012@gmail.com" -b 4096 -f $HOME/.ssh/id_rsa -P ""
bat ~/.ssh/id_rsa.pub
