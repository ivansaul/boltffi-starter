import ProjectDescription

let project = Project(
    name: "Demo",
    targets: [
        .target(
            name: "DemoMac",
            destinations: .macOS,
            product: .app,
            bundleId: "dev.tuist.mac.demo",
            deploymentTargets: .macOS("14.0"),
            infoPlist: .default,
            buildableFolders: [
                "macos/Sources",
                "macos/Resources",
            ],
            dependencies: [
                .external(name: "DemoCore"),
                .sdk(name: "SystemConfiguration", type: .framework, status: .required),
            ]
        ),
        .target(
            name: "DemoMacTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.mac.demoTests",
            infoPlist: .default,
            buildableFolders: [
                "macos/Tests"
            ],
            dependencies: [.target(name: "DemoMac")]
        ),
        .target(
            name: "DemoIOS",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.ios.demo",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            buildableFolders: [
                "ios/Sources",
                "ios/Resources",
            ],
            dependencies: [
                .external(name: "DemoCore"),
                .sdk(name: "SystemConfiguration", type: .framework, status: .required),
            ]
        ),
    ]
)
