#!/bin/bash
cd $(dirname $0)
git clone https://github.com/PurpleI2P/i2pd-android --recursive || true

cd i2pd-android
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/23.2.8568313"
pushd app/jni
./build_boost.sh
./build_openssl.sh
./build_miniupnpc.sh
popd
./gradlew clean assembleDebug
