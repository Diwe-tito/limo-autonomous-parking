#!/usr/bin/env bash
set -e

source /opt/ros/humble/setup.bash

# Workspace overlay if built
if [ -f "$HOME/limo_ws/install/setup.bash" ]; then
  source "$HOME/limo_ws/install/setup.bash"
fi

# 1) Generate URDF from xacro into a file (portable + avoids ROS arg parsing issues)
TMP_DIR="$HOME/limo_ws/tmp"
mkdir -p "$TMP_DIR"

XACRO_FILE="$HOME/limo_ws/src/limo_ros2/limo_description/urdf/limo_xacro.xacro"
URDF_OUT="$TMP_DIR/limo.urdf"

echo "Generating URDF..."
xacro "$XACRO_FILE" > "$URDF_OUT"

# 2) Start Gazebo (empty world) in background
echo "Starting Gazebo..."
ros2 launch gazebo_ros gazebo.launch.py >/tmp/gazebo.log 2>&1 &
GAZEBO_PID=$!

# 3) Start robot_state_publisher
echo "Starting robot_state_publisher..."
ros2 run robot_state_publisher robot_state_publisher --ros-args \
  --params-file <(python3 - <<'PY'
import yaml
urdf=open("$HOME/limo_ws/tmp/limo.urdf","r",encoding="utf-8").read()
print(yaml.dump({"robot_state_publisher":{"ros__parameters":{"robot_description":urdf}}}))
PY
) >/tmp/rsp.log 2>&1 &
RSP_PID=$!

sleep 3

# 4) Spawn into Gazebo
echo "Spawning robot into Gazebo..."
ros2 run gazebo_ros spawn_entity.py -topic /robot_description -entity limo

echo "Done. Gazebo PID: $GAZEBO_PID | RSP PID: $RSP_PID"
echo "Use teleop in a new terminal: ros2 run teleop_twist_keyboard teleop_twist_keyboard"
wait

