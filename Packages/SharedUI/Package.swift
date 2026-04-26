// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SharedUI",
    platforms: [.iOS(.v16), .macOS(.v12)],
    products: [
        .library(name: "SharedUI", targets: ["SharedUI"]),
    ],
    targets: [
        .target(name: "SharedUI"),
    ]
)
