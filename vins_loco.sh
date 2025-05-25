gnome-terminal --window -e 'bash -c "roscore; exec bash"' \
--tab -e 'bash -c "sleep 4; roslaunch mavros px4.launch; exec bash"' \
--tab -e 'bash -c "sleep 8; roslaunch realsense2_camera rs_camera.launch; exec bash"' \
--tab -e 'bash -c "sleep 14; roslaunch vins fast_drone_250.launch; exec bash"' \
--tab -e 'bash -c "sleep 18; rosrun px4_mavros_controller odom_to_pose.py; exec bash"' \