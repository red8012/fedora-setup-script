#!/bin/bash

# strict mode
set -euo pipefail
IFS=$'\n\t'

function ask() {
    read -p "$1? (y/n) "
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        return 0
    fi
    return 1
}

read -p "Run sudo visudo and add your_user_name ALL=(ALL) NOPASSWD:ALL at the bottom."

if ask "Turn off unused search settings (manually)" 
then
    gnome-control-center
fi

if ask "Set mutter rt-scheduler" 
then
    dconf write /org/gnome/mutter/experimental-features "['rt-scheduler']"
fi

if ask "Disable avahi-daemon.service, ModemManager.service" 
then
    sudo systemctl disable avahi-daemon.service
    sudo systemctl disable ModemManager.service
fi

if ask "Install Gnome extensions (manually)" 
then
    firefox --new-tab https://extensions.gnome.org/extension/1262/bing-wallpaper-changer/
    firefox --new-tab https://extensions.gnome.org/extension/1160/dash-to-panel/
    # firefox https://extensions.gnome.org/extension/1253/extended-gestures/
fi

read -p "HINT: Set Firefox homepage (manually) [Enter]"
if ask "Install AdBlock (manually)" 
then
    firefox --new-tab "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/"
fi

if ask "Remove Gnome Software" 
then
    sudo dnf remove gnome-software
fi

if ask "Upgrade system" 
then
    sudo dnf upgrade
fi

if ask "Install software" 
then
    sudo dnf makecache
    sudo dnf install nodejs yarnpkg zsh bat fzf grubby gnome-tweaks cargo youtube-dl zopfli aria2 tldr dconf-editor lollypop filezilla audacity seahorse transmission make nosync thefuck util-linux-user nano meld htop parallel iotop meson cmake gnome-todo mosh renameutils lsd
    pip install --user pypyp
fi

if ask "Install VSCode" 
then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf install code
fi

if ask "Install non-free codecs from RPMFusion" 
then
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install gstreamer1-libav gstreamer1-plugins-good-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-free-extras
    sudo dnf install lame
    sudo dnf group upgrade --with-optional Multimedia
fi

if ask "Install bandwhich" 
then
    sudo dnf copr enable atim/bandwhich
    sudo dnf install bandwhich
fi

if ask "Install Google Chrome" 
then
    firefox --new-tab https://google.com/chrome
fi

if ask "Install Terminus" 
then
    firefox --new-tab https://github.com/Eugeny/terminus/releases
fi

if ask "Install Gitahead" 
then
    firefox --new-tab https://gitahead.github.io/gitahead.com/
fi

if ask "Set keyboard.dispatch in VSCode to keyCode (manually)" 
then
    code
fi

if ask "Set kernel parameters" 
then
    sudo grubby --update-kernel=ALL --args="mitigations=off selinux=0 audit=0 hardened_usercopy=off noautogroup nowatchdog"
fi

if ask "Install MesloLGS Nerd Fonts (used by powerline10k)" 
then
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
    echo
    read -p "HINT: Please set terminal font to MesloLGS Nerd (manually)."
fi
echo
echo "HINT: Please set shell to ZSH (manually)."
read -p "Terminal -> Preferences -> Profile -> Commands -> check both, input zsh [Enter]" 

if ask "Set up Antibody (may take a minute)" 
then
    curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
    cp zshrc $HOME/.zshrc
    cp zsh_plugins.txt $HOME/.zsh_plugins.txt
    antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
    cp p10k.zsh $HOME/.p10k.zsh
    sudo chsh -s /usr/bin/zsh $USER
fi

if ask "Install fkill" 
then
    sudo yarn global add fkill-cli
fi

if ask "Setup hosts file" 
then
    wget -O /tmp/hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts
    sudo install -o root --backup=numbered /tmp/hosts /etc/hosts
    rm /tmp/hosts
fi

if ask "Set sysctl.conf" 
then
    echo "vm.swappiness = 1" | sudo tee -a /etc/sysctl.conf
    echo "vm.dirty_background_bytes = 16777216" | sudo tee -a /etc/sysctl.conf
    echo "kernel.sched_latency_ns = 3000000" | sudo tee -a /etc/sysctl.conf # 1/4
    echo "kernel.sched_min_granularity_ns = 300000" | sudo tee -a /etc/sysctl.conf # 1/5
    echo "kernel.sched_wakeup_granularity_ns = 500000" | sudo tee -a /etc/sysctl.conf # 1/4
    echo "net.ipv4.tcp_slow_start_after_idle = 0" | sudo tee -a /etc/sysctl.conf
    bat /etc/sysctl.conf
fi

if ask "Disable Systemd persistent log (to reduce disk writes)" 
then
    echo "Storage=volatile" | sudo tee -a /etc/systemd/journald.conf
    echo "RuntimeMaxFileSize=100K" | sudo tee -a /etc/systemd/journald.conf
    echo "RuntimeMaxUse=1M" | sudo tee -a /etc/systemd/journald.conf
fi

if ask "Install Poetry" 
then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
fi

if ask "Generate SSH key" 
then
    read -p "Enter email: "
    ssh-keygen -t rsa -C "$REPLY" -b 4096 -f $HOME/.ssh/id_rsa -P ""
    bat $HOME/.ssh/id_rsa
fi

if ask "Install color folder" 
then
    git clone --depth 1 https://github.com/alex285/Adwaita-Supplementary-Folders /tmp/icons
    mv /tmp/icons/512x512/places ~/.icons
fi

if ask "Install patched libinput" 
then
    pushd /tmp
    wget -O libinput.zip https://gitlab.freedesktop.org/red8012/libinput/-/archive/accelerated-scroll/libinput-accelerated-scroll.zip
    unzip libinput.zip
    pushd libinput-accelerated-scroll
    sudo dnf builddep libinput
    meson --prefix=/usr -Ddocumentation=false -Dtests=false -Ddebug-gui=false builddir/
    ninja -C builddir/
    sudo ninja -C builddir/ install
    popd
    popd
fi

if ask "Set git global name and email" 
then
    read -p "Enter name: "
    git config --global user.name "$REPLY"
    read -p "Enter email: "
    git config --global user.email "$REPLY"
fi
