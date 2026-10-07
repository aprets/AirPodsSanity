#!/bin/sh
# Build the app with the Command Line Tools alone. No Xcode needed.
set -eu
cd "$(dirname "$0")"

swift build -c release

APP="build/AirPods Sanity.app"
rm -rf build
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" build/AppIcon.iconset
cp ".build/release/AirPods Sanity" "$APP/Contents/MacOS/"
cp -R en.lproj de.lproj "AirPods Sanity/airpods-icon.png" "AirPods Sanity/airpods-icon@2x.png" "$APP/Contents/Resources/"

# actool needs Xcode, so make the app icon with sips and iconutil.
for size in 16 32 128 256; do
	sips -z $size $size "AirPods Sanity/Assets.xcassets/AppIcon.appiconset/appicon.png" --out "build/AppIcon.iconset/icon_${size}x${size}.png" >/dev/null
	sips -z $((size * 2)) $((size * 2)) "AirPods Sanity/Assets.xcassets/AppIcon.appiconset/appicon.png" --out "build/AppIcon.iconset/icon_${size}x${size}@2x.png" >/dev/null
done
cp "AirPods Sanity/Assets.xcassets/AppIcon.appiconset/appicon.png" build/AppIcon.iconset/icon_512x512.png
iconutil -c icns build/AppIcon.iconset -o "$APP/Contents/Resources/AppIcon.icns"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key><string>en</string>
	<key>CFBundleExecutable</key><string>AirPods Sanity</string>
	<key>CFBundleIconFile</key><string>AppIcon</string>
	<key>CFBundleIdentifier</key><string>eu.punke.AirPods-Sanity</string>
	<key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
	<key>CFBundleName</key><string>AirPods Sanity</string>
	<key>CFBundlePackageType</key><string>APPL</string>
	<key>CFBundleShortVersionString</key><string>1.0</string>
	<key>CFBundleVersion</key><string>1.0.5.0</string>
	<key>LSMinimumSystemVersion</key><string>13.0</string>
	<key>LSUIElement</key><true/>
</dict>
</plist>
PLIST

codesign --force --sign - --options runtime --entitlements "AirPods Sanity/AirPods_Sanity.entitlements" "$APP"

echo "Built $APP"
