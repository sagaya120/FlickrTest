// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FlickrTest",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "FlickrTest",
            targets: ["FlickrTest"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FlickrTest",
            dependencies: []),
        .testTarget(
            name: "FlickrTestTests",
            dependencies: ["FlickrTest"]),
    ]
) 