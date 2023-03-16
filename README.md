
在mac上用Android NDK编译zlib，openssl，curl。在linux上应该也没问题。在Windows上需要安装mingw或cygwin。

我是用的NDK版本是23.1.7779620

zlib版本zlib-1.2.13 https://www.zlib.net/zlib-1.2.13.tar.gz

openssl版本openssl-3.0.7 https://www.openssl.org/source/old/3.0/openssl-3.0.7.tar.gz

curl版本curl-7.88.0 https://curl.se/download/curl-7.88.0.tar.xz

curl依赖于zlib和openssl。所以先编译zlib和openssl再编译curl。ios使用内置的zlib。


Build Android

build-android-env.sh

```shell
#NDK路径
export ANDROID_NDK_ROOT=$HOME/Library/Android/sdk/ndk/23.1.7779620

#编译平台,我这是mac，所以是darwin-x86_64
HOST_TAG=darwin-x86_64

#Android api版本
MIN_SDK_VERSION=23

#工具链路径
TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/$HOST_TAG

#把工具链加入PATH环境变量
PATH=$TOOLCHAIN/bin:$PATH

#编译目录
BUILD_DIR=$PWD/build
```


```shell
#编译zlib
sh build-android-zlib.sh

#编译openssl
sh build-android-zopenssl.sh

#编译curl
sh build-android-zcurl.sh


#or
sh build-android.sh
```

Build iOS

build-ios-env.sh

```shell
#!/bin/bash

IOS_MIN_SDK_VERSION=12.0

BUILD_DIR=$PWD/build/ios
```

```shell
#编译openssl
sh build-ios-zopenssl.sh

#编译curl
sh build-ios-zcurl.sh


#or
sh build-ios.sh
```
