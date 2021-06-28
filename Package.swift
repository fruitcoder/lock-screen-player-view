// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "LockScreenPlayerView",
	platforms: [.iOS(.v13)],
	products: [
		.library(
			name: "LockScreenPlayerView",
			targets: ["LockScreenPlayerView"]
		),
	],
	dependencies: [
		.package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.9.0"),
	],
	targets: [
		.target(
			name: "LockScreenPlayerView",
			dependencies: []
		),
		.testTarget(
			name: "LockScreenPlayerViewTests",
			dependencies: [
				"LockScreenPlayerView",
				.product(name: "SnapshotTesting", package: "SnapshotTesting")
			],
			exclude: ["__Snapshots__"]
		)
	]
)
