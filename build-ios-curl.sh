#!/bin/sh

source ./build-ios-env.sh

ARCHIVE=curl-7.88.0.tar.xz

DIR=curl-7.88.0

VERSION=7.88.0

INSTALL_DIR=$BUILD_DIR/curl

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
  
    export CC=$(xcrun -find -sdk $SDK gcc)
    export CFLAGS="-arch $ARCH -pipe -Os -gdwarf-2 -isysroot $SDKDIR -m$SDK-version-min=$IOS_MIN_SDK_VERSION"
    export LDFLAGS="-arch $ARCH -isysroot $SDKDIR"

    ./configure \
       --host="$HOST-apple-darwin" \
       --disable-shared \
       --with-zlib=$SDKDIR/usr \
       --with-openssl=$BUILD_DIR/openssl/"$ARCH"_"$SDK" \
       --prefix=$INSTALL_DIR/"$ARCH"_"$SDK"

    make -j`sysctl -n hw.logicalcpu_max`
    make install
    make clean
}


build arm64   arm     iphoneos
build arm64   arm     iphonesimulator
build x86_64  x86_64  iphonesimulator



lipo \
   -arch arm64  $INSTALL_DIR/arm64_iphonesimulator/lib/libcurl.a \
   -arch x86_64 $INSTALL_DIR/x86_64_iphonesimulator/lib/libcurl.a \
   -create -output $INSTALL_DIR/libcurl.a


mkdir -p $INSTALL_DIR/iphoneos/curl.framework/Headers 
mkdir -p $INSTALL_DIR/iphonesimulator/curl.framework/Headers

libtool -no_warning_for_no_symbols -static -o $INSTALL_DIR/iphoneos/curl.framework/curl $INSTALL_DIR/arm64_iphoneos/lib/libcurl.a
cp -r $INSTALL_DIR/arm64_iphoneos/include/curl/ $INSTALL_DIR/iphoneos/curl.framework/Headers

libtool -no_warning_for_no_symbols -static -o $INSTALL_DIR/iphonesimulator/curl.framework/curl $INSTALL_DIR/libcurl.a
cp -r $INSTALL_DIR/arm64_iphonesimulator/include/curl/ $INSTALL_DIR/iphonesimulator/curl.framework/Headers

if [ -d $BUILD_DIR/curl.xcframework ];then
    rm -rf $BUILD_DIR/curl.xcframework
fi

xcodebuild -create-xcframework \
    -framework $INSTALL_DIR/iphoneos/curl.framework \
    -framework $INSTALL_DIR/iphonesimulator/curl.framework \
    -output $BUILD_DIR/curl.xcframework
plutil -insert CFBundleVersion -string $VERSION $BUILD_DIR/curl.xcframework/Info.plist


rm -rf $INSTALL_DIR/iphoneos
rm -rf $INSTALL_DIR/iphonesimulator

rm $INSTALL_DIR/libcurl.a

cd ..

rm -rf $DIR