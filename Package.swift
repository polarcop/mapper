// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mapper",
    products: [
        .library(
            name: "Mapper",
            targets: ["Mapper"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Mapper",
            dependencies: []),
        .testTarget(
            name: "MapperTests",
            dependencies: ["Mapper"]),
    ]
)
