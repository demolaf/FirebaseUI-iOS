// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseAuthSwiftUI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FirebaseAuthSwiftUI",
            targets: ["FirebaseAuthSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "12.2.0"),
    ],
    targets: [
        .target(
            name: "FirebaseAuthSwiftUI",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
        ),
        .testTarget(
            name: "FirebaseAuthSwiftUITests",
            dependencies: ["FirebaseAuthSwiftUI"]
        ),
    ]
)
