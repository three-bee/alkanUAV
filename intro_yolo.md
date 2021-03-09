# Introduction to YOLO - Fix

## Prerequisites
* This is based on Intelligent Quads' work. Clone the repo from [here](https://github.com/Intelligent-Quads/iq_tutorials). Below tutorial is a prerequisite:
  * [Using MAVROS to Get Telemetry Data - Fix](https://github.com/3b83/siha_sim/blob/main/mavros_fix.md)
* Then, follow [Introduction to YOLO/Darknet Image Recognition](https://github.com/Intelligent-Quads/iq_tutorials/blob/master/docs/intro_to_yolo.md). Continue with the video tutorial.
## Problem and Fix
When running ``` roslaunch darknet_ros darknet_ros.launch ```, you may encounter with a problem due to building Darknet incorrectly. This causes camera window to not open. To fix, 
```
#For Ubuntu 20. For 18, change clone git addresses.

#If you did not clone the repo already, follow the below code block
cd ~/catkin_ws/src
git clone https://github.com/kunaltyagi/darknet_ros.git
cd darknet_ros
git checkout opencv4
git submodule update --init --recursive
catkin build -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=/usr/bin/gcc-8

#Remove darknet_ros folder
rm -r -f darknet_ros

#Reclone the repo and build again without DCMAKE_C_COMPILER flag
git clone https://github.com/kunaltyagi/darknet_ros.git 
cd darknet_ros
git checkout opencv4
git submodule update --init --recursive
catkin build -DCMAKE_BUILD_TYPE=Release 
```
Run the simulation environment as told in the tutorial video.
