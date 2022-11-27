// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v11), .iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        
        .library(
            name: "InputReader",
            targets: ["InputReader"]),
        
        .library(
            name: "StandardLibraries",
            targets: ["StandardLibraries"]),
        
        .library(
            name: "Year2015",
            targets: ["Year2015"]),
        
        .library(
            name: "Year2016",
            targets: ["Year2016"]),
    
        .library(
            name: "Year2017",
            targets: ["Year2017"]),
    
        .library(
            name: "Year2018",
            targets: ["Year2018"]),
    
        .library(
            name: "Year2019",
            targets: ["Year2019"]),
    
        .library(
            name: "Year2020",
            targets: ["Year2020"]),
    
        .library(
            name: "Year2021",
            targets: ["Year2021"]),
    
        .library(
            name: "Year2022",
            targets: ["Year2022"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        .target(
            name: "InputReader",
            dependencies: []),
        .testTarget(
            name: "InputReaderTests",
            dependencies: ["InputReader"],
            resources: [
                .process("Resources"),
            ]),
        
        .target(
            name: "StandardLibraries",
            dependencies: []),
        .testTarget(
            name: "StandardLibrariesTests",
            dependencies: ["StandardLibraries"],
            resources: [
                .process("Resources"),
            ]),

        .target(
            name: "Year2015",
            dependencies: ["StandardLibraries"]),
        .testTarget(
            name: "Year2015Tests",
            dependencies: [
                "InputReader",
                "StandardLibraries",
                "Year2015"
            ],
            resources: [
                .process("Resources"),
            ]),
        
        .target(
            name: "Year2016",
            dependencies: ["StandardLibraries"]),
        .testTarget(
            name: "Year2016Tests",
            dependencies: [
                "InputReader",
                "StandardLibraries",
                "Year2016"
            ],
            resources: [
                .process("Resources"),
            ]),
        
        .target(
            name: "Year2017",
            dependencies: ["StandardLibraries"]),
        .testTarget(
            name: "Year2017Tests",
            dependencies: [
                "InputReader",
                "StandardLibraries",
                "Year2017"
            ],
            resources: [
                .process("Resources"),
            ]),
        
        .target(
            name: "Year2018",
            dependencies: ["StandardLibraries"]),
        .testTarget(
            name: "Year2018Tests",
            dependencies: [
                "InputReader",
                "StandardLibraries",
                "Year2018"
            ],
            resources: [
                .process("Resources"),
            ]),
        
        .target(
            name: "Year2019",
            dependencies: ["InputReader", "StandardLibraries"]),
        .testTarget(
            name: "Year2019Tests",
            dependencies: [
                "InputReader",
                "StandardLibraries",
                "Year2019"
            ],
            resources: [
                .process("Resources"),
            ]),
        
        .target(
            name: "Year2020",
            dependencies: ["StandardLibraries"]),
        .testTarget(
            name: "Year2020Tests",
            dependencies: [
                "InputReader",
                "StandardLibraries",
                "Year2020"
            ],
            resources: [
                .process("Resources"),
            ]),
        
        .target(
            name: "Year2021",
            dependencies: ["StandardLibraries"]),
        .testTarget(
            name: "Year2021Tests",
            dependencies: [
                "InputReader",
                "StandardLibraries",
                "Year2021"
            ],
            resources: [
                .process("Resources"),
            ]),
        
        .target(
            name: "Year2022",
            dependencies: ["StandardLibraries"]),
        .testTarget(
            name: "Year2022Tests",
            dependencies: [
                "InputReader",
                "StandardLibraries",
                "Year2022"
            ],
            resources: [
                .process("Resources"),
            ]),
    ]
)
