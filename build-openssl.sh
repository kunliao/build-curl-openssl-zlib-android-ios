#!/bin/bash

tar xvf openssl-3.0.7.tar.gz

source ./build_env.sh

INSTALL_DIR=$BUILD_DIR/openssl

if [ ! -d $INSTALL_DIR ]; then
    mkdir -p $INSTALL_DIR
fi

cd openssl-3.0.7

if [ -f Makefile ]; then
    make distclean
fi


#arm64-v8a
TARGET_HOST=aarch64-linux-android
ANDROID_ARCH=arm64-v8a
AR=$TOOLCHAIN/bin/llvm-ar
CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
AS=$CC
CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
LD=$TOOLCHAIN/bin/ld
RANLIB=$TOOLCHAIN/bin/llvm-ranlib
STRIP=$TOOLCHAIN/bin/llvm-strip

./Configure android-arm64 no-unit-test no-shared  no-ssl3 -D__ANDROID_API__=$MIN_SDK_VERSION --prefix=$INSTALL_DIR/$ANDROID_ARCH

make -j8
make install_sw
make distclean


#armeabi-v7a
TARGET_HOST=armv7a-linux-androideabi
ANDROID_ARCH=armeabi-v7a
AR=$TOOLCHAIN/bin/llvm-ar
CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
AS=$CC
CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
LD=$TOOLCHAIN/bin/ld
RANLIB=$TOOLCHAIN/bin/llvm-ranlib
STRIP=$TOOLCHAIN/bin/llvm-strip

./Configure android-arm no-shared no-unit-test no-ssl3 -D__ANDROID_API__=$MIN_SDK_VERSION --prefix=$INSTALL_DIR/$ANDROID_ARCH

make -j8
make install_sw
make distclean


#x86
TARGET_HOST=i686-linux-android
ANDROID_ARCH=x86
AR=$TOOLCHAIN/bin/llvm-ar
CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
AS=$CC
CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
LD=$TOOLCHAIN/bin/ld
RANLIB=$TOOLCHAIN/bin/llvm-ranlib
STRIP=$TOOLCHAIN/bin/llvm-strip

./Configure android-x86 no-shared no-unit-test no-ssl3 -D__ANDROID_API__=$MIN_SDK_VERSION --prefix=$INSTALL_DIR/$ANDROID_ARCH

make -j8
make install_sw
make distclean


#x86_64
TARGET_HOST=x86_64-linux-android
ANDROID_ARCH=x86_64
AR=$TOOLCHAIN/bin/llvm-ar
CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
AS=$CC
CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
LD=$TOOLCHAIN/bin/ld
RANLIB=$TOOLCHAIN/bin/llvm-ranlib
STRIP=$TOOLCHAIN/bin/llvm-strip

./Configure android-x86_64 no-shared no-unit-test no-ssl3 -D__ANDROID_API__=$MIN_SDK_VERSION --prefix=$INSTALL_DIR/$ANDROID_ARCH

make -j8
make install_sw
#make distclean

cd ..

rm -rf openssl-3.0.7