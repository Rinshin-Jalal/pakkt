// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Pakkt",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Pakkt",
            targets: ["Pakkt"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0")
    ],
    targets: [
        .target(
            name: "Pakkt",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        ),
        .testTarget(
            name: "PakktTests",
            dependencies: ["Pakkt"]
        )
    ]
)
