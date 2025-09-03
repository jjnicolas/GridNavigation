// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GridNavigationExample",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .executable(name: "GridNavigationExample", targets: ["GridNavigationExample"])
    ],
    dependencies: [
        .package(path: "../../")
    ],
    targets: [
        .executableTarget(
            name: "GridNavigationExample",
            dependencies: [
                .product(name: "GridNavigation", package: "GridNavigation")
            ]
        )
    ]
)