#!/bin/bash

tar xzf zlib-1.2.13.tar.gz

source ./build-env.sh

INSTALL_DIR=$BUILD_DIR/zlib

if [ ! -d $INSTALL_DIR ]; then
    mkdir -p $INSTALL_DIR
fi

cd zlib-1.2.13


function build() {
    make distclean
    TARGET_HOST=$1
    ANDROID_ARCH=$2
    AR=$TOOLCHAIN/bin/llvm-ar
    CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
    AS=$CC
    CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
    LD=$TOOLCHAIN/bin/ld
    RANLIB=$TOOLCHAIN/bin/llvm-ranlib
    STRIP=$TOOLCHAIN/bin/llvm-strip

    ./configure --prefix=$INSTALL_DIR/$ANDROID_ARCH --static

    make -j8
    make install
    make distclean
}

build aarch64-linux-android arm64-v8a
build armv7a-linux-androideabi armeabi-v7a
build i686-linux-android x86
build x86_64-linux-android x86_64

cd ..

rm -rf cd zlib-1.2.13