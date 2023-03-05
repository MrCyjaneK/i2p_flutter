# i2p_flutter

_Because I don't feel like teaching users on how to configure tunnels._

## Project status

This project is made entirely for [p3pch4t](https://github.com/mrcyjanek/p3pch4t), with the intention of being useful for other projects too.

To build this project you need to build android i2pd (check external/android-i2pd/build.sh).

Then copy libi2pd.so into android/jniLibs/{arm64-v8a,armeabi-v7a,x86_64} - or you can grab binary releases from https://github.com/PurpleI2P/i2pd-android (`i2pd_*_android_binary.zip`). 

NOTE: After compiling from source make sure to remove the external/android-i2pd/i2pd-android directory or it will make dart addons to VS Code / Android Studio unusable and fail to analyze your code.