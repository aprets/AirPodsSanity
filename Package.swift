// swift-tools-version:5.9
// Local build without Xcode: run ./build.sh.
import PackageDescription

let package = Package(
	name: "AirPodsSanity",
	platforms: [.macOS(.v13)],
	dependencies: [
		.package(url: "https://github.com/rnine/SimplyCoreAudio.git", revision: "343d463cffef1f30458d02ce2dc441138e9e0134"),
		.package(url: "https://github.com/sindresorhus/LaunchAtLogin-Modern", revision: "a04ec1c363be3627734f6dad757d82f5d4fa8fcc"),
	],
	targets: [
		.executableTarget(
			name: "AirPods Sanity",
			dependencies: ["SimplyCoreAudio", .product(name: "LaunchAtLogin", package: "LaunchAtLogin-Modern")],
			path: "AirPods Sanity",
			exclude: ["Assets.xcassets", "Preview Content", "AirPods_Sanity.entitlements", "airpods-icon.png", "airpods-icon@2x.png"]
		),
	]
)
