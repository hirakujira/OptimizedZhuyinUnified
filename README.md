# Optimized Zhuyin

## Features

Change iOS Zhuyin keyboard layout.

修改 iOS 注音鍵盤排列方式

[Screenshots](https://hiraku.tw/2012/02/2855/)

## Install

Optimized Zhuyin Unified is available on Hiraku's repo. (https://cydia.hiraku.tw)

## Bulid for iOS 5

Since `libstdc++` is requried for iOS 5 devices but not included in Xcode 10+, if you want to build this tweak for iOS 5, please download Xcode 9.4.1 and add the following function to your `~/.zshrc` or `~/.bashrc`, then run `makelegacy` and `make install`.

```
makelegacy() {
 export DEVELOPER_DIR=/opt/theos/toolchain/Xcode-9.4.1.app
 targetArchs="armv7 armv7s arm64"
 echo "building ARCHS $targetArchs"
 make ARCHS="$targetArchs"

 echo "checking to see if tweak targets arm64e"
 cat Makefile | grep arm64e
 if [[ $? == 0 ]]; then
  echo "✅ tweak appears to target arm64e"
  targetArchs="armv7 armv7s arm64 arm64e"
  export DEVELOPER_DIR=/Applications/Xcode.app
  echo "DEVELOPER_DIR set to $DEVELOPER_DIR"
  echo "building ARCHS $targetArchs"
  make package ARCHS="$targetArchs"
 else
  echo "❌ tweak does not appear to target arm64e"
  make package ARCHS="$targetArchs"
 fi

 unset DEVELOPER_DIR
 echo "DEVELOPER_DIR unset"
}
```

## License

MIT. Please kindly keep the credit of contributors.