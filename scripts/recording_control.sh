#!/bin/bash

rosbag record \
/mavros/setpoint_raw/attitude \
/mavros/local_position/odom \
/quadrotor/position_cmd \
/quadrotor/so3_cmd \
/quadrotor_ukf/control_odom \
/tf \
/qvio/pose \
/mavros/local_position/odom \
/imu/data \
/imu_apps \
/mavros/imu/data \
/mavros/imu/data_raw \
/mavros/vision_pose/pose \
/tof_conf \
/tof_depth \
/tof_ir \
/tof_pc \

