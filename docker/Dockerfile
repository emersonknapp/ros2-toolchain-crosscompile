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
    python3-pip \
    wget \
  && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install -U colcon-mixin

# Create the workspace
RUN mkdir /ws
WORKDIR /ws
RUN mkdir src

# Add toolchain and mixins for compile arguments
COPY cc-mixin-index.yaml .
COPY cross-compile.mixin .
COPY linaro-toolchain.cmake .

RUN colcon mixin add cc file:///ws/cc-mixin-index.yaml
RUN colcon mixin update cc

ENV TARGET_ARCH=aarch64
ENV CROSS_COMPILE=/ws/gcc-linaro-aarch64/bin/aarch64-linux-gnu-
ENV SYSROOT=/ws/sysroot-linaro6.5
ENV ROS2_INSTALL_PATH=/ws/install
ENV PYTHON_SOABI=cpython-36m-aarch64-linux-gnu
