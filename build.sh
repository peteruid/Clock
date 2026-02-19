#!/bin/bash
set -e

echo "Building Flip Clock..."
swift build -c release

APP_DIR="FlipClock.app/Contents/MacOS"
mkdir -p "$APP_DIR"
mkdir -p "FlipClock.app/Contents"

cp .build/release/Clock "$APP_DIR/Clock"
cp Sources/Info.plist "FlipClock.app/Contents/Info.plist"

mkdir -p "FlipClock.app/Contents/Resources"
cp Resources/AppIcon.icns "FlipClock.app/Contents/Resources/AppIcon.icns"

echo "Built FlipClock.app successfully."
echo "Run with: open FlipClock.app"
