#!/bin/bash

# Install dependecies
export DEBIAN_FRONTEND=noninteractive
apt-get update 

# list of packages to be installed
packagelist=(
    apt-utils
    build-essential
    cmake
    initramfs-tools
    libboost-all-dev
    libboost-dev
    libbz2-dev
    libc6-dev
    libconsole-bridge-dev
    libgtest-dev
    liblog4cxx10
    liblog4cxx10-dev
    liblz4-dev
    libtinyxml-dev
    libpython2.7-stdlib
    libyaml-cpp-dev
    libyaml-dev
    python-coverage
    python-empy
    python-imaging
    python-mock
    python-netifaces
    python-nose
    python-numpy
    python-paramiko
    python-pip
    python-yaml
)

apt-get install -y ${packagelist[@]}


# Upgrade pip version
pip install --upgrade setuptools

# Use pip to intall ros
pip install -U rosdep rosinstall_generator wstool rosinstall catkin_pkg rospkg

# Install sbcl 
wget http://netcologne.dl.sourceforge.net/project/sbcl/sbcl/1.2.7/sbcl-1.2.7-armel-linux-binary.tar.bz2
tar -xjf sbcl-1.2.7-armel-linux-binary.tar.bz2
cd sbcl-1.2.7-armel-linux 
chmod +x install.sh 
INSTALL_ROOT=/usr/local 
./install.sh
cd ..

# Initiallize ros
rosdep init
sed -i -e '2iyaml https://raw.githubusercontent.com/moriarty/ros-ev3/master/ev3dev.yaml\' /etc/ros/rosdep/sources.list.d/20-default.list
rosdep update

mkdir ~/ros_comm
cd ~/ros_comm 
rosinstall_generator ros_comm common_msgs --rosdistro jade --deps --wet-only --tar > jade-ros_comm-wet.rosinstall
wstool init src jade-ros_comm-wet.rosinstall
rosdep check --from-paths src --ignore-src --rosdistro jade -y --os=debian:jessie
./src/catkin/bin/catkin_make_isolated --install --install-space /opt/ros/jade -DCMAKE_BUILD_TYPE=Release
echo "source /opt/ros/jade/setup.bash" >> ~/.bashrc

# Enable ros to robot user
echo "source /opt/ros/jade/setup.bash" >> /home/robot/.bashrc

# Change timeout to allow ros_core start
sed -i -- 's/_TIMEOUT_MASTER_START = 10/_TIMEOUT_MASTER_START = 100/' /opt/ros/jade/lib/python2.7/dist-packages/roslaunch/launch.py
