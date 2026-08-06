// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftMach",
    products: [
        .library(name: "Kernel", type: .static, targets: ["Kernel"]),
    ],
    targets: [
        .target(
            name: "Kernel",
            dependencies: [],
            path: "Sources/Kernel",
            swiftSettings: [
                .unsafeFlags(["-enable-experimental-feature", "Embedded"])
            ]
        ),
    ]
)
