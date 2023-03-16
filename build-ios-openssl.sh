#!/bin/sh

source ./build-ios-env.sh

ARCHIVE=openssl-3.0.7.tar.gz

DIR=openssl-3.0.7

VERSION=3.0.7

INSTALL_DIR=$BUILD_DIR/openssl

if [ -d $INSTALL_DIR ]; then
    rm -rf "$INSTALL_DIR"*
fi

mkdir -p $INSTALL_DIR

if [ -d $DIR ];then
    rm -rf $DIR
fi

tar xzf $ARCHIVE

cd $DIR

function build() {
    ARCH=$1
    HOST=$2
    SDK=$3
    SDKDIR=$(xcrun --sdk $SDK --show-sdk-path)
   

    export CC=$(xcrun -find -sdk $SDK clang)
    export CFLAGS="-arch $ARCH -pipe -Os -gdwarf-2 -isysroot $SDKDIR -m$SDK-version-min=$IOS_MIN_SDK_VERSION"
    export LDFLAGS="-arch $ARCH -isysroot $SDKDIR"

    ./configure no-unit-test no-shared --prefix=$INSTALL_DIR/"$ARCH"_"$SDK" $HOST
    
    make -j $(sysctl -n hw.logicalcpu_max) 
    make install_sw
    make distclean
}



build arm64    ios64-xcrun         iphoneos
build arm64    iossimulator-xcrun  iphonesimulator
build x86_64   iossimulator-xcrun  iphonesimulator



lipo \
   -arch arm64  $INSTALL_DIR/arm64_iphonesimulator/lib/libssl.a \
   -arch x86_64 $INSTALL_DIR/x86_64_iphonesimulator/lib/libssl.a \
   -create -output $INSTALL_DIR/libssl.a
lipo \
   -arch arm64  $INSTALL_DIR/arm64_iphonesimulator/lib/libcrypto.a \
   -arch x86_64 $INSTALL_DIR/x86_64_iphonesimulator/lib/libcrypto.a \
   -create -output $INSTALL_DIR/libcrypto.a


mkdir -p $INSTALL_DIR/iphoneos/openssl.framework/Headers 
mkdir -p $INSTALL_DIR/iphonesimulator/openssl.framework/Headers


libtool -no_warning_for_no_symbols -static -o \
$INSTALL_DIR/iphoneos/openssl.framework/openssl  \
$INSTALL_DIR/arm64_iphoneos/lib/libssl.a \
$INSTALL_DIR/arm64_iphoneos/lib/libcrypto.a 

cp -r $INSTALL_DIR/arm64_iphoneos/include/openssl/ $INSTALL_DIR/iphoneos/openssl.framework/Headers

libtool -no_warning_for_no_symbols -static -o \
$INSTALL_DIR/iphonesimulator/openssl.framework/openssl \
$INSTALL_DIR/libssl.a \
$INSTALL_DIR/libcrypto.a



cp -r $INSTALL_DIR/arm64_iphonesimulator/include/openssl/ $INSTALL_DIR/iphonesimulator/openssl.framework/Headers


if [ -d $BUILD_DIR/openssl.xcframework ];then
    rm -rf $BUILD_DIR/openssl.xcframework
fi

xcodebuild -create-xcframework \
    -framework $INSTALL_DIR/iphoneos/openssl.framework \
    -framework $INSTALL_DIR/iphonesimulator/openssl.framework \
    -output $BUILD_DIR/openssl.xcframework
plutil -insert CFBundleVersion -string $VERSION $BUILD_DIR/openssl.xcframework/Info.plist


rm -rf $INSTALL_DIR/iphoneos
rm -rf $INSTALL_DIR/iphonesimulator

rm $INSTALL_DIR/libcrypto.a
rm $INSTALL_DIR/libssl.a 

cd ..

rm -rf $DIR