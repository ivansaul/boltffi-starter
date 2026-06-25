import ProjectDescription

let project = Project(
    name: "Demo",
    targets: [
        .target(
            name: "DemoShared",
            destinations: [.mac, .iPhone],
            product: .framework,
            bundleId: "dev.tuist.demo.shared",
            deploymentTargets: .multiplatform(iOS: "17.0", macOS: "14.0"),
            infoPlist: .default,
            sources: ["shared/Sources/**"],
            dependencies: [
                .external(name: "DemoCore"),
                .sdk(name: "SystemConfiguration", type: .framework, status: .required),
            ]
        ),
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
                .target(name: "DemoShared"),
            ]
        ),
        .target(
            name: "DemoMacTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.mac.demoTests",
            infoPlist: .default,
            buildableFolders: [
                "macos/Tests",
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
                .target(name: "DemoShared"),
            ]
        ),
    ]
)
