#!/bin/bash

tar xvf zlib-1.2.13.tar.gz

source ./build_env.sh

INSTALL_DIR=$BUILD_DIR/zlib

if [ ! -d $INSTALL_DIR ]; then
    mkdir -p $INSTALL_DIR
fi

cd zlib-1.2.13

make distclean

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

./configure --prefix=$INSTALL_DIR/$ANDROID_ARCH --static

make -j8
make install
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

./configure --prefix=$INSTALL_DIR/$ANDROID_ARCH --static

make -j8
make install
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

./configure --prefix=$INSTALL_DIR/$ANDROID_ARCH --static

make -j8
make install
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

./configure --prefix=$INSTALL_DIR/$ANDROID_ARCH --static

make -j8
make install
#make distclean

cd ..

rm -rf cd zlib-1.2.13