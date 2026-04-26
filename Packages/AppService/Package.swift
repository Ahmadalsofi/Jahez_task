// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AppService",
    platforms: [.iOS(.v16), .macOS(.v12)],
    products: [
        .library(name: "AppService", targets: ["AppService"]),
        .library(name: "AppServiceMocks", targets: ["AppServiceMocks"]),
    ],
    dependencies: [
        .package(path: "../NetworkKit"),
    ],
    targets: [
        .target(
            name: "AppService",
            dependencies: ["NetworkKit"]
        ),
        .target(
            name: "AppServiceMocks",
            dependencies: ["AppService", "NetworkKit"]
        ),
        .testTarget(
            name: "AppServiceTests",
            dependencies: ["AppService", "AppServiceMocks", "NetworkKit"]
        ),
    ]
)
