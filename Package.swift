// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RxSwiftConnect",
    platforms: [
           .macOS(.v10_14), .iOS(.v10), .tvOS(.v10)
    ],
    products: [
        .library(name: "RxSwiftConnect",
                 targets: ["RxSwiftConnect"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMinor(from: "6.5.0")),
        .package(url: "https://github.com/kirualex/SwiftyGif.git", .upToNextMinor(from: "5.4.3"))
       
    ],
    targets: [
        .target(
            name: "RxSwiftConnect",
            dependencies: ["RxSwift", "SwiftyGif"],
            path: "RxSwiftConnect"
        )
        
    ]
)
