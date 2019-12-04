# ROS2 toolchain cross-compiler

This is a very minimal pass at a workflow that can use a custom toolchain to create a ROS2 build.

It cannot handle dependencies that are outside the source tree, so there is only a limited subset of ROS2 that this can build.

As of right now, it is specifically tuned to using a linaro aarch64 cross compiler, but to make it generic should not take much modification.

# Main Process

## Setup

You need to have Docker and `vcs` installed on your dev computer already

1. Download the linaro cross compiler (6.5)
    * https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/aarch64-linux-gnu/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu.tar.xz
    * extract it fully into this repo and change the directory's name to `gcc-linaro-aarch64/`
1. Download the linaro sysroot (6.5)
    *  https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/aarch64-linux-gnu/sysroot-glibc-linaro-2.23-2018.12-aarch64-linux-gnu.tar.xz
    *  extract it fully into this repo and change the directory's name to `sysroot-linaro6.5`
1. Get the ROS2 sources

```
vcs import src < minimal_cpp_ros2_master.repos
# we do not have log4cxx dependency and don't actually need it
touch src/ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
```

## Running the build

Start the container from the top dir of this repo

```
docker run -it -v $(pwd):/ws/ros2build candleends/ros2_cross_compiler
```

Now run the build within the container

```
colcon build --mixin aarch64-linux --packages-up-to demo_nodes_cpp
```

## Deploying the build

Exit the build container. The `install/` directory is your ROS2 build.

```
adb push install /userdata/install
```

## Try the build

Open one `adb shell` to the device

```
export LD_LIBRARY_PATH=/userdata/install/lib
/userdata/install/lib/demo_nodes_cpp/talker
```

Then, in a second `adb shell`

```
export LD_LIBRARY_PATH=/userdata/install/lib
/userdata/install/lib/demo_nodes_cpp/listener
```

Now, you should see that the listener is receiving messages from the talker.

# Tips / Advice

## Rebuilding the Docker image

If you need to change the docker image that we use for building, it's easy to rebuild

```
cd docker
docker build . -t candleends/ros2_cross_compiler
```

# Building and running AWS Kinesis Video Streams

There are a few low level dependencies that need to cross compiled, in order to use the AWS C++ SDKs: zlib, openssl, and curl

```
docker run -it -v $(pwd):/ws/ros2build candleends/ros2_cross_compiler

# build those dependencies from source
mkdir cross_output
mkdir cross_dependency_sources
touch cross_dependency_sources/COLCON_IGNORE
pushd cross_dependency_sources
../cross-compile-deps.bash
popd

# the dependencies were installed into cross_output, install them into the sysroot so that the build can find them
cp -RT cross_output/ sysroot-linaro6.5/
```

Now, you can perform the cross-compilation build of the ros2 stack

```
colcon build --mixin aarch64-linux --packages-up-to kinesis-test
```

## Configuring credentials on the device
1. You need CA Certificates for curl to use for HTTPS.

```
# WARNING: don't do this in production! this is just to get the same certs as your dev machine available on the device
adb push /etc/ssl/certs /etc/ssl
```

2. you also need AWS credentials for your app to access AWS services. Set the contents of `/.aws/credentials` on the device

```
[default]
aws_access_key_id = YOUR_AWS_ACCESS_KEY_ID
aws_secret_access_key = YOUR_AWS_SECRET_ACCESS_KEY
```

## Deploy

```
adb push cross_output/ /userdata/
adb push install /userdata/
```

on the device
```
cp -r /userdata/cross_output/. /
export LD_LIBRARY_PATH=/userdata/install/lib/
```

## Try it out

```
/userdata/install/lib/kinesis
```
