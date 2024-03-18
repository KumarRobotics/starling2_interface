# starling2_interface
Starling 2 Interface is meant to be used in cooperation with the following packages: 

[repo::branch - link]     
kr_falcon_interface::master - https://github.com/tyuezhan/kr_falcon250_interface/tree/master   
kr_mav_control::master - https://github.com/KumarRobotics/kr_mav_control   
quadrotor_ukf::starling2_integration - https://github.com/tyuezhan/quadrotor_ukf/tree/starling2_integration    


# Starling2 Setup
## Wifi Setup 
The Starling 2 only has DHCP, so setting a Static IP is not possible [0], meaning you have to set the IP through the router. After powering on the Starling 2, connect to the wifi with the following command:  

`voxl-wifi`

After this, enter `2` for station and enter `mrsl_mast` for SSID and enter the password. Get the password from senior lab members if you don’t know it. To set up the static IP, connect to the mrsl_mast network and go to `192.168.8.1` to get to the router. Username is `admin` and you can get the password from Fernando Cladera. 
Once on the website, go to the Advanced tab and click on the `Setup` drop-down and click on `LAN Setup`. Click `Add` and find the device corresponding to your device.  
This drone will be identified by the last numbers of this IP. I.E, if the IP Address assigned is `192.168.8.45`, the drone will be labeled with a `45`. We will represent this identification number as `<starling_number>`

## Install ROS Melodic  
Voxl2 runs Ubuntu 18.04 and ROS Melodic can be installed by following the instructions here: https://docs.modalai.com/ros-installation-voxl2/    
Install deps: 
```
sudo apt-get install python3-catkin-tools libeigen3-dev ros-melodic-tf2-ros python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential ros-melodic-tf2-geometry-msgs ros-melodic-tf ros-melodic-tf2-eigen ros-melodic-angles ros-melodic-tf-conversions ros-melodic-mavros-msgs ros-melodic-mavros rsync tmux ros-melodic-camera-info-manager
```   

## Autonomy Stack Setup:  
On your LOCAL MACHINE run the following:
```
mkdir -p ~/voxl2_home/autonomy_ws/src
cd ~/voxl2_home/autonomy_ws/src
git clone git@github.com:KumarRobotics/starling2_interface.git
git clone git@github.com:tyuezhan/kr_falcon250_interface.git
git clone git@github.com:tyuezhan/quadrotor_ukf.git -b starling2_integration
git clone git@github.com:KumarRobotics/kr_mav_control.git
cd ../..
git clone git@gitlab.com:voxl-public/support/mavros_test.git
git clone git@github.com:KumarRobotics/voxl-mpa-to-ros.git
echo -e '#!/bin/bash\n\nif [ $# -ne 1 ]; then\n    echo "Usage: $0 <last_digits_of_IP>"\n    exit 1\nfi\n\nlast_digits=$1\ndestination="192.168.8.$last_digits"\n\nrsync -avz --recursive --progress --exclude '\''*/build/*'\'' --exclude '\''*.git'\'' --exclude '\''*/devel/*'\'' --exclude '\''*.bag'\'' ~/voxl2_home/ root@$destination:/home/root/kumarRobotics/' > voxl_sync.sh
chmod +x ./voxl_sync.sh
voxl_sync.sh <starling_number>
```
The drone now has all of the source code needed to begin flying. SSH back onto the drone and run the following:
```
cd ~/kumarRobotics/autonomy_ws
catkin build
cd ../mavros_test
./build.sh
cd ../voxl-mpa-to-ros
./build.sh qrb5165
cp ~/kumarRobotics/autonomy_ws/src/starling2_interface/scripts/flight_start.sh ~/
cp ~/kumarRobotics/autonomy_ws/src/starling2_interface/scripts/recording_control.sh ~/
mv ~/.profile.d ~/old_profile_d
```


### Vicon Setup
```
<launch>
  <node pkg="mocap_vicon"
    type="mocap_vicon_node"
    name="vicon"
    output="screen">
    <param name="server_address" value="mocap.perch"/>
    <param name="frame_rate" value="5"/>
    <param name="max_accel" value="10.0"/>
    <param name="publish_tf" value="true"/>
    <param name="fixed_frame_id" value="mocap"/>
    <rosparam param="model_list">['Starling2']</rosparam>
    <!--remap from="vicon/Starling2/odom" to="mocap_vicon"/-->
  </node>
</launch>
```

References:   
[0] https://docs.modalai.com/voxl-2-wifi-setup/    
