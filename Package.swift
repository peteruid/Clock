// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Clock",
    platforms: [.macOS("26.0")],
    targets: [
        .executableTarget(
            name: "Clock",
            path: "Sources",
            exclude: ["Info.plist"],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-sectcreate",
                              "-Xlinker", "__TEXT",
                              "-Xlinker", "__info_plist",
                              "-Xlinker", "Sources/Info.plist"])
            ]
        )
    ]
)
