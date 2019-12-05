FROM ubuntu:bionic

# Get ROS2 apt repos
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

RUN apt-get update && apt-get install -q -y \
       tzdata \
       locales \
       curl \
       gnupg2 \
       lsb-release \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
RUN locale-gen en_US $LANG && update-locale LC_ALL=$LANG LANG=$LANG

RUN curl http://repo.ros2.org/repos.key | apt-key add - \
    && sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'

# Install necessary build tools
RUN apt-get update && apt-get install -y \
    cmake \
    git \
    python3-colcon-common-extensions \
    python3-lark-parser \
    python3-pip \
    wget \
  && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install -U colcon-mixin

# Create the workspace
RUN mkdir -p /ws/ros2build

# Add toolchain and mixins for compile arguments
COPY cc-mixin-index.yaml /ws/
COPY cross-compile.mixin /ws/
COPY linaro-toolchain.cmake /ws/

WORKDIR /ws/ros2build

RUN colcon mixin add cc file:///ws/cc-mixin-index.yaml
RUN colcon mixin update cc

ENV TARGET_ARCH=aarch64
ENV CROSS_COMPILE=/ws/ros2build/gcc-linaro-aarch64/bin/aarch64-linux-gnu-
ENV SYSROOT=/ws/ros2build/sysroot-linaro6.5
ENV ROS2_INSTALL_PATH=/ws/ros2build/install
ENV PYTHON_SOABI=cpython-36m-aarch64-linux-gnu
ENV ROS_DISTRO=eloquent
ENV ROS_VERSION=2
