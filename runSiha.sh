#!/bin/bash
gnome-terminal \
--tab -t 'ROS_ArduCopter' -e 'roslaunch iq_sim multi_drone_with_camera.launch' \
--tab -t 'Drone1' -e 'sim_vehicle.py -v ArduCopter -f gazebo-iris -I0 --console --out 127.0.0.1:14553' \
--tab -t 'Drone2' -e 'sim_vehicle.py -v ArduCopter -f gazebo-iris -I1 --console --out 127.0.0.1:14563' \

sleep 5

gnome-terminal \
 --tab -t 'ROS_APM' -e 'roslaunch iq_sim multi-apm_with_camera.launch' \
 --tab -t 'ROS_Topics' -e 'rostopic list' \
 
sleep 20
 
gnome-terminal \
 --tab -t 'dronekit_1' -e "python3 /home/$USER/dronekit-python/examples/simple_goto/simple_goto.py --connect 127.0.0.1:14553" \
 
clear
