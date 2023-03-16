#!/bin/bash

source ./build-android-env.sh

ARCHIVE=openssl-3.0.7.tar.gz

DIR=openssl-3.0.7

INSTALL_DIR=$BUILD_DIR/openssl

if [ -d $INSTALL_DIR ]; then
    rm -rf $INSTALL_DIR
fi

mkdir -p $INSTALL_DIR

if [ -d $DIR ];then
    rm -rf $DIR
fi

tar xzf $ARCHIVE

cd $DIR

function build() {
    TARGET_HOST=$1
    ANDROID_ARCH=$2
    OPENSSL_ARCH=$3
    AR=$TOOLCHAIN/bin/llvm-ar
    CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
    AS=$CC
    CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
    LD=$TOOLCHAIN/bin/ld
    RANLIB=$TOOLCHAIN/bin/llvm-ranlib
    STRIP=$TOOLCHAIN/bin/llvm-strip

    ./Configure $OPENSSL_ARCH no-unit-test no-shared -D__ANDROID_API__=$MIN_SDK_VERSION --prefix=$INSTALL_DIR/$ANDROID_ARCH

    make -j8
    make install_sw
    make distclean
}

build aarch64-linux-android arm64-v8a android-arm64
build armv7a-linux-androideabi armeabi-v7a android-arm
build i686-linux-android x86 android-x86
build x86_64-linux-android x86_64 android-x86_64


cd ..

rm -rf $DIR