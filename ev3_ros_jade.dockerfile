FROM ev3dev/ev3dev-jessie-ev3-generic

# Install dependecies
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --force-yes \
    apt-utils \
    build-essential \
    cmake \
    initramfs-tools \
    libboost-all-dev \
    libboost-dev \
    libbz2-dev \
    libc6-dev \
    libconsole-bridge-dev \
    libgtest-dev \
    liblog4cxx10 \
    liblog4cxx10-dev \
    liblz4-dev \
    libtinyxml-dev \
    libpython2.7-stdlib \
    libyaml-cpp-dev \
    libyaml-dev \
    python-coverage \ 
    python-empy \
    python-imaging \
    python-mock \
    python-netifaces \
    python-nose \
    python-numpy \
    python-paramiko \
    python-pip \
    python-yaml

# Upgrade pip version
RUN sudo pip install --upgrade setuptools

# Use pip to intall ros
RUN sudo pip install -U rosdep rosinstall_generator wstool rosinstall catkin_pkg rospkg

# Install sbcl 
RUN sudo  wget http://netcologne.dl.sourceforge.net/project/sbcl/sbcl/1.2.7/sbcl-1.2.7-armel-linux-binary.tar.bz2
RUN sudo tar -xjf sbcl-1.2.7-armel-linux-binary.tar.bz2
RUN cd sbcl-1.2.7-armel-linux && sudo chmod +x install.sh && INSTALL_ROOT=/usr/local && sudo sh install.sh
RUN cd ..

# Initiallize ros
RUN sudo rosdep init
RUN sudo sed -i -e '2iyaml https://raw.githubusercontent.com/moriarty/ros-ev3/master/ev3dev.yaml\' /etc/ros/rosdep/sources.list.d/20-default.list
RUN sudo rosdep update

RUN sudo mkdir ~/ros_comm
RUN cd ~/ros_comm && sudo rosinstall_generator ros_comm common_msgs --rosdistro jade --deps --wet-only --tar > jade-ros_comm-wet.rosinstall
RUN cd ~/ros_comm && sudo wstool init src jade-ros_comm-wet.rosinstall
RUN cd ~/ros_comm && sudo rosdep check --from-paths src --ignore-src --rosdistro jade -y --os=debian:jessie
RUN cd ~/ros_comm && sudo ./src/catkin/bin/catkin_make_isolated --install --install-space /opt/ros/jade -DCMAKE_BUILD_TYPE=Release
RUN sudo echo "source /opt/ros/jade/setup.bash" >> ~/.bashrc

# Enable ros to robot user
RUN sudo echo "source /opt/ros/jade/setup.bash" >> /home/robot/.bashrc

# Change timeout to allow ros_core start
RUN sudo sed -i -- 's/_TIMEOUT_MASTER_START = 10/_TIMEOUT_MASTER_START = 100/' /opt/ros/jade/lib/python2.7/dist-packages/roslaunch/launch.py
