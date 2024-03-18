#!/bin/bash
session="starling_kr"
ip_add=$(ip -f inet addr show wlan0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
echo "${ip_add}"

systemctl restart voxl-imu-server
systemctl restart voxl-qvio-server

tmux new-session -d -s $session

window=0
tmux rename-window -t $session:$window 'roscore'
tmux send-keys -t $session:$window 'source /opt/ros/melodic/setup.bash' C-m
tmux send-keys -t $session:$window 'export ROS_IP='"${ip_add}" C-m
tmux send-keys -t $session:$window 'roscore' C-m

window=1
tmux new-window -t $session:$window -n 'mpa_to_ros'
tmux send-keys -t $session:$window 'source ~/kumarRobotics/voxl-mpa-to-ros/catkin_ws/devel/setup.bash' C-m
tmux send-keys -t $session:$window 'export ROS_IP='"${ip_add}" C-m
tmux send-keys -t $session:$window 'roslaunch --wait voxl_mpa_to_ros voxl_mpa_to_ros.launch' C-m

window=2
tmux new-window -t $session:$window -n 'system.launch'
tmux send-keys -t $session:$window 'source ~/kumarRobotics/autonomy_ws/devel/setup.bash' C-m
tmux send-keys -t $session:$window 'export ROS_IP='"${ip_add}" C-m
tmux send-keys -t $session:$window 'export PX4_SYS_ID=1' C-m
tmux send-keys -t $session:$window 'roslaunch --wait starling2_interface system.launch' 

window=3
tmux new-window -t $session:$window -n 'bag'
tmux send-keys -t $session:$window 'source /opt/ros/melodic/setup.bash' C-m
tmux send-keys -t $session:$window 'source ~/kumarRobotics/autonomy_ws/devel/setup.bash' C-m
# tmux send-keys -t $session:$window 'source ~/kumarRobotics/voxl-mpa-to-ros/catkin_ws/devel/setup.bash' C-m
tmux send-keys -t $session:$window 'export ROS_IP='"${ip_add}" C-m
tmux send-keys -t $session:$window '~/recording_control.sh' C-m

window=4
tmux new-window -t $session:$window -n 'voxl-inspect'
tmux send-keys -t $session:$window 'systemctl restart voxl-imu-server' C-m
tmux send-keys -t $session:$window 'systemctl restart voxl-qvio-server' C-m
tmux send-keys -t $session:$window 'voxl-inspect-qvio' C-m
tmux split-window -v  
tmux select-pane -t 1
tmux send-keys -t $session:$window 'voxl-inspect-imu imu_apps' C-m

window=5
tmux new-window -t $session -n "Kill"
tmux send-keys -t $session "tmux send-keys -t ${session}:3 C-c && sleep 3 && sleep 1 && tmux kill-session -t ${session}"

tmux select-window -t $session:4
tmux attach-session -t $session
