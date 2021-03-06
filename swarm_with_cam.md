# Drone swarm with camera

## Prerequisites
* This is based on Intelligent Quads' work. Clone the repo from [here](https://github.com/Intelligent-Quads/iq_tutorials). Then, follow the tutorials:
  * Installing Ardupilot and MAVProxy [20.04]
  * Installing QGroundControl
  * Installing Gazebo and ArduPilot Plugin [18.04-20.04]
  * Installing ROS and MAVROS [20.04]
  * Drone Swarms with Ardupilot

## Changing necessary files
Most probably you have observed that the drones do not have a camera attached to them in **Drone Swarms with Ardupilot** tutorial. To add camera models, we need to change certain files.
```
#Change directory to models folder
cd ~/catkin_ws/src/iq_sim/models/

#Create 3 copies of drone_with_camera model folder
cp -r drone_with_camera drone1_with_camera
cp -r drone_with_camera drone2_with_camera
cp -r drone_with_camera drone3_with_camera
```
Below procedure is shown for the first drone. Repeat for all three in their corresponding model folder.
```
cd ~/catkin_ws/src/iq_sim/models/
cd drone1_with_camera
gedit model.config

#Change inside of the name tag (Line 4) with drone1_with_camera. Save and exit.


gedit model.sdf

# (Line 54-55)
#      <cameraName>webcam</cameraName>
#      <imageTopicName>image_raw</imageTopicName>
# To avoid conflictions in topic names, rename webcam with webcam_1 and image_raw with image_raw_1.
# Change the numbers accordingly for each drone model.


# (Line 209-210)
#      <fdm_port_in>9002</fdm_port_in>
#      <fdm_port_out>9003</fdm_port_out>
# For each drone, change input and output port.
# Drone 1: in:9002, out:9003
# Drone 2: in:9012, out:9013
# Drone 3: in:9022, out:9023
# i.e. increment in and out by 10 for each drone.

```

We created 3 distinct copies of the drone with a camera attached. Now, they need to be spawned in their corresponding world file. 
```
cd ~/catkin_ws/src/iq_sim/worlds/

# Create a copy of the multi_drone world.
cp multi_drone.world multi_drone_with_camera.world

gedit multi_drone_with_camera.world

#(Lines 80-97)
#    <model name="drone1_with_camera">
#     <pose> 0 0 0 0 0 0</pose>
#      <include>
#        <uri>model://drone1_with_camera</uri>
#      </include>
#    </model>
#    <model name="drone2_with_camera">
#      <pose> 0 -5 0 0 0 1.57</pose>
#      <include>
#        <uri>model://drone2_with_camera</uri>
#      </include>
#    </model>
#    <model name="drone3_with_camera">
#      <pose> 5 -5 0 0 0 3.14</pose>
#      <include>
#        <uri>model://drone3_with_camera</uri>
#      </include>
#    </model>
# Change as above. 
# Model name and uri needs to be the same as the name of the model folders we just copied in a few steps ago.
```
multi_drone_with_camera.world will now spawn the drones with cameras. Now, create the launch file which will run new the world file.
```
cd ~/catkin_ws/src/iq_sim/launch/

# Create a copy of the launch file.
cp multi_drone.launch multi_drone_with_camera.launch

gedit multi_drone_with_camera.launch

# Change line 4 with below line:
# <arg name="world_name" value="$(find iq_sim)/worlds/multi_drone_with_camera.world"/>
```

## Testing
```
#All in different terminals

roslaunch iq_sim multi_drone_with_camera.launch
sim_vehicle.py -v ArduCopter -f gazebo-iris -I0 --console --out 127.0.0.1:14553
sim_vehicle.py -v ArduCopter -f gazebo-iris -I1 --console --out 127.0.0.1:14563
sim_vehicle.py -v ArduCopter -f gazebo-iris -I2 --console --out 127.0.0.1:14573
rqt_image_view
```
There should be no conflictions of images in rqt_image_view and no error message should be shown in roslaunch terminal.
