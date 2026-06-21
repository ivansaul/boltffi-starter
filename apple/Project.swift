import ProjectDescription

let project = Project(
    name: "Kora",
    targets: [
        .target(
            name: "KoraMac",
            destinations: .macOS,
            product: .app,
            bundleId: "dev.tuist.mac.Kora",
            deploymentTargets: .macOS("14.0"),
            infoPlist: .default,
            buildableFolders: [
                "macos/Sources",
                "macos/Resources",
            ],
            dependencies: [
                .external(name: "KoraCore"),
                .sdk(name: "SystemConfiguration", type: .framework, status: .required),
            ]
        ),
        .target(
            name: "KoraMacTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.mac.KoraTests",
            infoPlist: .default,
            buildableFolders: [
                "macos/Tests"
            ],
            dependencies: [.target(name: "KoraMac")]
        ),
        .target(
            name: "KoraIOS",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.ios.Kora",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            buildableFolders: [
                "ios/Sources",
                "ios/Resources",
            ],
            dependencies: [
                .external(name: "KoraCore"),
                .sdk(name: "SystemConfiguration", type: .framework, status: .required),
            ]
        ),
    ]
)
