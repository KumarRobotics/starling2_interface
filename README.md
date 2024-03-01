# starling2_interface
Starling 2 Interface is meant to be used in cooperation with the following packages: 

// repo::branch - link 

kr_falcon_interface::master - https://github.com/tyuezhan/kr_falcon250_interface/tree/master 

kr_mav_control::master - https://github.com/KumarRobotics/kr_mav_control 

quadrotor_ukf::starling2_integration - https://github.com/tyuezhan/quadrotor_ukf/tree/starling2_integration 

TODO: Make Quadrotor_UKF public while keeping commit history and provide instructions for catkin_ws setup

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
