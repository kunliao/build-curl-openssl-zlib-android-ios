#!/bin/bash

tar xzf openssl-3.0.7.tar.gz

source ./build-env.sh

INSTALL_DIR=$BUILD_DIR/openssl

if [ ! -d $INSTALL_DIR ]; then
    mkdir -p $INSTALL_DIR
fi

cd openssl-3.0.7

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

rm -rf openssl-3.0.7