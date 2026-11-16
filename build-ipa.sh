#!/bin/bash
# 在 macOS（GitHub Actions runner）上交叉产出未签名 IPA
set -e
cd "$(dirname "$0")"

APP_NAME="QLPanel"
IPA_NAME="QinglongPanel-unsigned"

echo "=== 使用 SDK: $(xcrun -sdk iphoneos -show-sdk-path)"

rm -rf build
mkdir -p "build/Payload/${APP_NAME}.app"

echo "=== swiftc 编译 arm64 iOS 二进制..."
xcrun -sdk iphoneos swiftc \
  -target arm64-apple-ios14.0 \
  -sdk "$(xcrun -sdk iphoneos -show-sdk-path)" \
  -O \
  -framework UIKit -framework WebKit -framework Foundation \
  -o "build/Payload/${APP_NAME}.app/${APP_NAME}" \
  AppMain.swift

echo "=== 组装 .app 包..."
cp Info.plist "build/Payload/${APP_NAME}.app/"
cp icon-180.png "build/Payload/${APP_NAME}.app/AppIcon60x60@2x.png"

echo "=== 打包未签名 IPA..."
cd build
zip -qry "../${IPA_NAME}.ipa" Payload
cd ..

echo "=== 产物: ${IPA_NAME}.ipa ($(du -h ${IPA_NAME}.ipa | cut -f1))"
