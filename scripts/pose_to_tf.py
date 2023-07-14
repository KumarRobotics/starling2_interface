#!/usr/bin/env python

import rospy
import geometry_msgs
from geometry_msgs.msg import PoseStamped
import tf2_ros


class pose_to_tf:

    """
    Length Parameterization Node to allow easy variation for Length variables for a constant Number
    of Robots and Features
    """

    def __init__(self):

        rospy.init_node('pose_to_tf')
        rospy.Subscriber("/qvio/pose", PoseStamped, self.callback)
        self.broadcaster = tf2_ros.StaticTransformBroadcaster()
        rospy.spin()

    def callback(self, pose):
        rospy.loginfo("Received pose!")

        static_transformStamped = geometry_msgs.msg.TransformStamped()
        # static_transformStamped.stamp = rospy.Time.now()
        static_transformStamped.header.frame_id = "map"
        static_transformStamped.child_frame_id = "qvio"

        static_transformStamped.transform.translation.x = pose.pose.position.x
        static_transformStamped.transform.translation.y = pose.pose.position.y
        static_transformStamped.transform.translation.z = pose.pose.position.z

        static_transformStamped.transform.rotation.x = pose.pose.orientation.x
        static_transformStamped.transform.rotation.y = pose.pose.orientation.y
        static_transformStamped.transform.rotation.z = pose.pose.orientation.z
        static_transformStamped.transform.rotation.w = pose.pose.orientation.w
        self.broadcaster.sendTransform(static_transformStamped)


if __name__ == "__main__":
    parameterization = pose_to_tf()
