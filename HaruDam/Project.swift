// Project.swift
import ProjectDescription

let project = Project(
    name: "HaruDam",
    organizationName: "kr.co.HaruDam",
    packages: [
        .remote(
            url: "https://github.com/google/GoogleSignIn-iOS",
            requirement: .upToNextMajor(from: "9.0.0")
        ),
        .remote(
            url: "https://github.com/kakao/kakao-ios-sdk",
            requirement: .upToNextMajor(from: "2.26.0")
        ),
        .remote(
            url: "https://github.com/supabase-community/supabase-swift",
            requirement: .upToNextMajor(from: "2.5.1")
        )
    ],
    settings: .settings(
        base: [
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0"
        ]
    ),
    targets: [
        .target(
            name: "HaruDam",
            destinations: .iOS,
            product: .app,
            bundleId: "kr.co.HaruDam",
            deploymentTargets: .iOS("16.0"),
            // ⬇️ Project.swift 기준 상대 경로
            infoPlist: .file(path: "HaruDam/Info.plist"),
            sources: [
                "HaruDam/**"
            ],
            resources: [
                "HaruDam/Resources/**",
                "HaruDam/**/Assets.xcassets"
            ],
            dependencies: [
                .package(product: "GoogleSignIn"),
                .package(product: "Supabase"),
                .package(product: "KakaoSDK")
            ]
        ),
        .target(
            name: "HaruDamTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "kr.co.HaruDamTests",
            infoPlist: .default,
            sources: [
                "HaruDamTests/**"
            ],
            resources: [],
            dependencies: [
                .target(name: "HaruDam")
            ]
        )
    ]
)
