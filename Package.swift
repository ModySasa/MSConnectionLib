// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MSConnectionLib",
    platforms: [
        .iOS(.v15)
        ,.macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MSConnectionLib",
            targets: ["MSConnectionLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.1.0")),
        .package(url: "https://github.com/ModySasa/KeyPathCodingMacro", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MSConnectionLib"
            ,dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "KeyPathCodingMacro", package: "KeyPathCodingMacro"),
            ]
        ),
        .testTarget(
            name: "MSConnectionLibTests",
            dependencies: ["MSConnectionLib"]),
    ]
)
