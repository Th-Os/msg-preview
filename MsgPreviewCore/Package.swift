// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MsgPreviewCore",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "MsgPreviewCore", targets: ["MsgPreviewCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hughbe/MsgReader", from: "1.0.1"),
    ],
    targets: [
        .target(name: "MsgPreviewCore", dependencies: ["MsgReader"]),
        .testTarget(
            name: "MsgPreviewCoreTests",
            dependencies: ["MsgPreviewCore"],
            resources: [.copy("Resources")]),
    ]
)
