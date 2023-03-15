#!/bin/bash

tar xvf curl-7.88.0.tar.xz

source ./build_env.sh

INSTALL_DIR=$BUILD_DIR/curl

if [ ! -d $INSTALL_DIR ]; then
    mkdir -p $INSTALL_DIR
fi

cd curl-7.88.0

autoreconf -fi


#arm64-v8a
export TARGET_HOST=aarch64-linux-android
export ANDROID_ARCH=arm64-v8a
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
export AS=$CC
export CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

./configure --host=$TARGET_HOST \
            --target=$TARGET_HOST \
            --prefix=$INSTALL_DIR/$ANDROID_ARCH \
            --with-zlib=$BUILD_DIR/zlib/$ANDROID_ARCH \
            --with-openssl=$BUILD_DIR/openssl/$ANDROID_ARCH \
            --with-pic --disable-shared

make -j8
make install
make clean


# #armeabi-v7a
export TARGET_HOST=armv7a-linux-androideabi
export ANDROID_ARCH=armeabi-v7a
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
export AS=$CC
export CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip


./configure --host=$TARGET_HOST \
            --target=$TARGET_HOST \
            --prefix=$INSTALL_DIR/$ANDROID_ARCH \
            --with-zlib=$BUILD_DIR/zlib/$ANDROID_ARCH \
            --with-openssl=$BUILD_DIR/openssl/$ANDROID_ARCH \
            --with-pic --disable-shared

make -j8
make install
make clean


#x86
export TARGET_HOST=i686-linux-android
export ANDROID_ARCH=x86
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
export AS=$CC
export CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

./configure --host=$TARGET_HOST \
            --target=$TARGET_HOST \
            --prefix=$INSTALL_DIR/$ANDROID_ARCH \
            --with-zlib=$BUILD_DIR/zlib/$ANDROID_ARCH \
            --with-openssl=$BUILD_DIR/openssl/$ANDROID_ARCH \
            --with-pic --disable-shared

make -j8
make install
make clean


#x86_64
export TARGET_HOST=x86_64-linux-android
export ANDROID_ARCH=x86_64
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang
export AS=$CC
export CXX=$TOOLCHAIN/bin/$TARGET_HOST$MIN_SDK_VERSION-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

./configure --host=$TARGET_HOST \
            --target=$TARGET_HOST \
            --prefix=$INSTALL_DIR/$ANDROID_ARCH \
            --with-zlib=$BUILD_DIR/zlib/$ANDROID_ARCH \
            --with-openssl=$BUILD_DIR/openssl/$ANDROID_ARCH \
            --with-pic --disable-shared

make -j8
make install
#make clean


cd ..

rm -rf cd curl-7.88.0