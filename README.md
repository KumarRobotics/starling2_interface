# starling2_interface
Starling 2 Integration

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
