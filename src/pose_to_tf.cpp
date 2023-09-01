#include <ros/ros.h>
#include <geometry_msgs/PoseStamped.h>
#include <tf2_ros/static_transform_broadcaster.h>
#include <geometry_msgs/TransformStamped.h>

class PoseToTF
{
public:
    PoseToTF();

private:
    void callback(const geometry_msgs::PoseStamped::ConstPtr& pose);

    ros::NodeHandle nh, pnh;
    ros::Subscriber pose_sub_;
    tf2_ros::StaticTransformBroadcaster broadcaster_;
};

PoseToTF::PoseToTF() : pnh("~")
{
    pose_sub_ = nh.subscribe("/qvio/pose", 1, &PoseToTF::callback, this);
    ROS_INFO("pose_to_tf node started!");
    ros::spin();
}

void PoseToTF::callback(const geometry_msgs::PoseStamped::ConstPtr& pose)
{
  ROS_INFO("Received pose!");

  geometry_msgs::TransformStamped static_transformStamped;
  static_transformStamped.header.frame_id = "local";
  static_transformStamped.child_frame_id = "body_local";

  static_transformStamped.transform.translation.x = pose->pose.position.x;
  static_transformStamped.transform.translation.y = pose->pose.position.y;
  static_transformStamped.transform.translation.z = pose->pose.position.z;

  static_transformStamped.transform.rotation.x = pose->pose.orientation.x;
  static_transformStamped.transform.rotation.y = pose->pose.orientation.y;
  static_transformStamped.transform.rotation.z = pose->pose.orientation.z;
  static_transformStamped.transform.rotation.w = pose->pose.orientation.w;

  broadcaster_.sendTransform(static_transformStamped);
}

int main(int argc, char** argv) {
  ros::init(argc, argv, "starling2_tf");
  ROS_INFO("Initializing CPP test for tf");
  PoseToTF starling_pose;
  ros::Rate rate(2);
  while (ros::ok()) {
    ros::spinOnce();
    rate.sleep();
  }
}
