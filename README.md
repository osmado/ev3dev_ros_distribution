ev3dev-ros-jade
===============

This repository contains a docker file used to create a version of the ev3dev with the Jade ros distribution.  It is based on the moriarty's project "https://github.com/moriarty/ros-ev3" (thanks a lot for this project).

To build the imag goes to the directory where Dockerfile is located and execute:
   "$ docker build --force-rm -t ev3-ros-jade -f ev3_ros_jade.dockerfile ."

NOTE 1: build process takes a long time (about 1 hour in my case)
NOTE 2: build process genetes lot of warnings in some python code.  TODO: investigate this warnings.

Beside the dockerfile include a litle modification of launch.py (/opt/ros/jade/lib/python2.7/dist-packages/roslaunch/launch.py) code in order to allow ros_core be executed into EV3.

Following sections describe howto use this image. Examples on these sections use the ev3_ros_wiimote code.

Create the ros workspace
------------------------
This section describe howto use the previous generated image to create a ros workspace in the host computer.

- Make the directory in the host computer i.e: $ mkdir /home/oscar/workspace_docker/ev3_ros_robot
- Run the docker image: "$ docker run --rm -it -v /home/oscar/workspace_docker/ev3_ros_robot:/home/robot/ev3_ros_robot ev3-ros-jade su -l robot".  Into the shell:
	- sudo chown robot:robot ev3_ros_robot
	- cd ev3_ros_robot
	- mkdir src && cd src
	- catkin_init_workspace
	- cd ..
	- catkin_make
	- source de devel/setup.bash


Compiling a ros module
----------------------

Once the ros workspace has been created it can be used to compile ros modules.  This section isn't a step by step guide to create ros modules (ros wiki explains it in detail).


- Run the docker image with access to ros workspace: "$ docker run --rm -it -v /home/oscar/workspace_docker/ev3_ros_robot:/home/robot/ev3_ros_robot ev3-ros-jade su -l robot". Into the shell:
	- cd ev3_ros_robot
	- source devel/setup.bash 
	- cd src
	- catkin_create_pkg ev3_wiimote
	- cd ..
	- catkin_make (after a successsful build, we can start adding nodes to th src folder of this package).
	- don't close the docker image
- On the host computer we can use our favourite editor to create the source files into the src folder of the package. Remember edit package.xml and CMakeList.txt according to ros requirement.
- After source code is added goes into the docker shell again:
	- catkin_make



