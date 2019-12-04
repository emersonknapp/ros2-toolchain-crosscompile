#!/bin/bash -ex

export WS=/ws/ros2build
export CROSS_COMPILER_DIR=$WS/gcc-linaro-aarch64
export CROSS_COMPILE_SYSROOT=$WS/sysroot-linaro6.5
export CROSS_INSTALL_PREFIX=$WS/cross_output

export CROSS_COMPILE_BIN_PREFIX=$CROSS_COMPILER_DIR/bin/aarch64-linux-gnu
# export PATH=$CROSS_COMPILER_DIR/bin:$PATH

export CC=$CROSS_COMPILE_BIN_PREFIX-gcc
export CXX=$CROSS_COMPILE_BIN_PREFIX-g++
export LD=$CROSS_COMPILE_BIN_PREFIX-ld
export AR=$CROSS_COMPILE_BIN_PREFIX-ar
export AS=$CROSS_COMPILE_BIN_PREFIX-as
export NM=$CROSS_COMPILE_BIN_PREFIX-nm
export RANLIB=$CROSS_COMPILE_BIN_PREFIX-ranlib

export CFLAGS="--sysroot $CROSS_COMPILE_SYSROOT"
export CXXFLAGS="--sysroot $CROSS_COMPILE_SYSROOT"
export CPPFLAGS="--sysroot $CROSS_COMPILE_SYSROOT"
export LDFLAGS="--sysroot $CROSS_COMPILE_SYSROOT"

# # Zlib
# wget -c https://zlib.net/zlib-1.2.11.tar.gz
# tar xzf zlib-1.2.11.tar.gz
# pushd zlib-1.2.11
# ./configure --prefix=$CROSS_INSTALL_PREFIX
# make -j
# make install
# popd
#
# # openssl
# wget -c https://www.openssl.org/source/openssl-1.1.1c.tar.gz
# tar xzf openssl-1.1.1c.tar.gz
# pushd openssl-1.1.1c
# ./Configure --prefix=$CROSS_INSTALL_PREFIX linux-aarch64
# # Note: I don't quite understand why it messes up the prefixes on the build tools
# make CC=$CC LD=$LD AR=$AR AS=$AS NM=$NM RANLIB=$RANLIB -j
# make install_sw CC=$CC LD=$LD AR=$AR AS=$AS NM=$NM RANLIB=$RANLIB
# popd
#
# # curl
# wget -c https://curl.haxx.se/download/curl-7.65.1.tar.gz
# tar xzf curl-7.65.1.tar.gz
# pushd curl-7.65.1
# ./configure --prefix=$CROSS_INSTALL_PREFIX --host=aarch64-linux --with-zlib --with-ca-path=/etc/ssl/certs --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt
# make -j
# make install
# popd

## dependencies for kinesis video producer

# log4cplus
wget -c https://github.com/log4cplus/log4cplus/releases/download/REL_1_1_2/log4cplus-1.1.2.tar.gz
tar xzf log4cplus-1.1.2.tar.gz
pushd log4cplus-1.1.2
./configure --prefix=$CROSS_INSTALL_PREFIX --host=aarch64-linux --with-sysroot=$CROSS_COMPILE_SYSROOT
make -j
# make install
popd

# libgstreamer1.0-dev
# wget -O gstreamer-1.15.90.tar.gz https://github.com/GStreamer/gstreamer/archive/1.15.90.tar.gz
# tar xzf gstreamer-1.15.90.tar.gz
# pushd gstreamer-1.15.90
# ./autogen.sh --disable-gtk-doc
# ./configure --prefix=$CROSS_INSTALL_PREFIX --host=aarch64-linux
# make -j
# popd

# libgstreamer-plugins-base1.0-dev
# wget -O gstreamer-1.15.90.tar.gz https://github.com/GStreamer/gst-plugins-base/archive/1.15.90.tar.gz
