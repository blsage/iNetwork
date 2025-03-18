// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "iNetwork",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "iNetwork",
            targets: ["iNetwork"]
        ),
    ],
    targets: [
        .target(
            name: "iNetwork"
        ),
    ]
)
