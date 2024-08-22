#!/bin/bash

clear
session="starling_ground"

ip_add=$(ip -f inet addr show wlan0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
ip_star="192.168.8.1"

if [ -z "$ip_add" ]; then
  ip a
  echo -e "\e[32mUnable to detect Ground Control IP, Please Enter Manually:\033[0m " 
  read  ip_add
fi

echo -e "\e[32mPlease enter the IP Address of the Starling you wish to fly:\033[0m  " 
read ip_star

# echo "${ip_add}"

tmux new-session -d -s $session -n 'ctrl'

window=0
tmux send-keys -t $session:$window 'bash' C-m 
tmux send-keys -t $session:$window 'clear' C-m 
tmux send-keys -t $session:$window 'ssh root@'"${ip_star}" C-m
tmux split-window -h  
tmux select-pane -t 1
tmux send-keys -t $session:$window 'distrobox enter noetic' C-m 
sleep 2
tmux send-keys -t $session:$window 'clear' C-m 
tmux send-keys -t $session:$window 'export ROS_IP='"${ip_add}" C-m 
tmux send-keys -t $session:$window 'export ROS_HOSTNAME=ros' C-m 
tmux send-keys -t $session:$window 'export ROS_MASTER_URI=http://'"${ip_star}"':11311' C-m 
tmux send-keys -t $session:$window 'source ~/voxl2_home/autonomy_ws/devel/setup.bash' C-m 
tmux send-keys -t $session:$window 'python3 ~/voxl2_home/autonomy_ws/src/kr_mav_control/rqt_mav_manager/scripts/rqt_mav_manager' 

tmux split-window -v  
tmux select-pane -t 2
tmux send-keys -t $session:$window 'distrobox enter noetic' C-m 
sleep 2
tmux send-keys -t $session:$window 'clear' C-m 
tmux send-keys -t $session:$window 'export ROS_IP='"${ip_add}" C-m 
tmux send-keys -t $session:$window 'export ROS_HOSTNAME=ros' C-m 
tmux send-keys -t $session:$window 'export ROS_MASTER_URI=http://'"${ip_star}"':11311' C-m 
tmux send-keys -t $session:$window 'source ~/voxl2_home/autonomy_ws/devel/setup.bash' C-m 
tmux send-keys -t $session:$window 'rosservice call /mavros/cmd/arming "value: true"'  

window=1
tmux new-window -t $session -n "kill"
tmux send-keys -t $session:$window 'bash' C-m 
tmux send-keys -t $session:$window 'clear' C-m 
tmux send-keys -t $session "tmux kill-session -t ${session}"

tmux select-window -t 'ctrl'
tmux attach-session -t $session
