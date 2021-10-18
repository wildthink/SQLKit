// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SQLKit",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "SQLKit", targets: ["SQLKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SQLKit", dependencies: [
            .product(name: "Logging", package: "swift-log"),
        ]),
        .testTarget(name: "SQLKitTests", dependencies: [
            .target(name: "SQLKit"),
        ]),
    ]
)
