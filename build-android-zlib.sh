#!/bin/bash

source ./build-android-env.sh

ARCHIVE=zlib-1.2.13.tar.gz

DIR=$PWD/zlib-1.2.13

INSTALL_DIR=$BUILD_DIR/zlib

if [ -d $INSTALL_DIR ]; then
    rm -rf $INSTALL_DIR
fi

mkdir -p $INSTALL_DIR

if [ -d $DIR ];then
    rm -rf $DIR
fi

tar -xzf $ARCHIVE

cd $DIR

function build() {
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

rm -rf $DIR