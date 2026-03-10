from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():

    robot_state_publisher_node = Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        parameters=['/home/tito/limo_ws/tmp/rsp_diff_odom.yaml'],
        output='screen'
    )

    spawn_entity_node = Node(
        package='gazebo_ros',
        executable='spawn_entity.py',
        arguments=[
            '-topic', 'robot_description',
            '-entity', 'limo'
        ],
        output='screen'
    )

    return LaunchDescription([
        robot_state_publisher_node,
        spawn_entity_node
    ])

