// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Macaw",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "Macaw", 
            targets: ["Macaw"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/ftp27/SWXMLHash",
            from: "7.0.3"
        )
    ],
    targets: [
        .target(
            name: "Macaw",
            dependencies: ["SWXMLHash"],
            path: "Source",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
        .testTarget(
            name: "MacawTests",
            dependencies: ["Macaw"],
            path: "MacawTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
