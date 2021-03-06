# Using MAVROS to Get Telemetry Data - Fix

## Prerequisites
* This is based on Intelligent Quads' work. Clone the repo from [here](https://github.com/Intelligent-Quads/iq_tutorials). Then, follow the tutorials:
  * [Drone swarm with camera](https://github.com/3b83/siha_sim/blob/main/swarm_with_cam.md)
* This tutorial file is an extension of [Introduction to Ros for Autonomous Drones](https://github.com/Intelligent-Quads/iq_tutorials/blob/master/docs/ros_intro.md) in order to avoid a few problems and make it suitable for the swarm scenario with cameras.
  * Follow above tutorial until you run into a problem concerning ```apm.launch``` file. You should end up with a looping text inside the terminal.
    * If no problem occurs, safely skip to "Creating a new ```multi-apm_with_camera.launch``` for drone swarm with cameras". **Do not change the udp adresses in that case**. 
## Fix for ```apm.launch``` & ```multi-apm.launch```
```
cd ~/catkin_ws/src/iq_sim/launch/

gedit apm.launch

# Change (Line 5) with below line:
# <arg name="fcu_url" default="udp://127.0.0.1:14551@" />

gedit multi-apm.launch
# Similarly, change the udp adresses for all drones such that it ends with @
```
## Creating a new ```multi-apm_with_camera.launch``` file for drone swarm with cameras
```
cd ~/catkin_ws/src/iq_sim/launch/

cp multi-apm.launch multi-apm_with_camera.launch

gedit multi-apm_with_camera.launch
```
Change ```ns``` and ```fcu_url``` params for each drone. You should end up with the following:
```
<launch>
	<node pkg="mavros" type="mavros_node" name="mavros" required="false" clear_params="true" output="screen" respawn="true" ns="/drone1_with_camera">
		<param name="fcu_url" value="udp://127.0.0.1:14551@" />
		<param name="gcs_url" value="" />
		<param name="target_system_id" value="1" />
		<param name="target_component_id" value="1" />
		<param name="fcu_protocol" value="v2.0" />

		<!-- load blacklist, config -->
		<rosparam command="load" file="$(find mavros)/launch/apm_pluginlists.yaml" />
		<rosparam command="load" file="$(find mavros)/launch/apm_config.yaml" />
	</node>

	<node pkg="mavros" type="mavros_node" name="mavros" required="false" clear_params="true" output="screen" respawn="true" ns="/drone2_with_camera">
		<param name="fcu_url" value="udp://127.0.0.1:14561@" />
		<param name="gcs_url" value="" />
		<param name="target_system_id" value="2" />
		<param name="target_component_id" value="1" />
		<param name="fcu_protocol" value="v2.0" />

		<!-- load blacklist, config -->
		<rosparam command="load" file="$(find mavros)/launch/apm_pluginlists.yaml" />
		<rosparam command="load" file="$(find mavros)/launch/apm_config.yaml" />
	</node>
	<node pkg="mavros" type="mavros_node" name="mavros" required="false" clear_params="true" output="screen" respawn="true" ns="/drone3_with_camera">
		<param name="fcu_url" value="udp://127.0.0.1:14571@" />
		<param name="gcs_url" value="" />
		<param name="target_system_id" value="3" />
		<param name="target_component_id" value="1" />
		<param name="fcu_protocol" value="v2.0" />

		<!-- load blacklist, config -->
		<rosparam command="load" file="$(find mavros)/launch/apm_pluginlists.yaml" />
		<rosparam command="load" file="$(find mavros)/launch/apm_config.yaml" />
	</node>
</launch>
```
Notice that ```ns``` parameters take cloned model names of the drones with camera.

## Testing
```
roslaunch iq_sim multi_drone_with_camera.launch
sim_vehicle.py -v ArduCopter -f gazebo-iris -I0 --console --out 127.0.0.1:14553
sim_vehicle.py -v ArduCopter -f gazebo-iris -I1 --console --out 127.0.0.1:14563
sim_vehicle.py -v ArduCopter -f gazebo-iris -I2 --console --out 127.0.0.1:14573

#Wait for the first roslaunch to initialize. Then run:
roslaunch iq_sim multi-apm_with_camera.launch
rostopic list
```
You should see all topics of all three drones, including the data taken from telemetry and camera. 
