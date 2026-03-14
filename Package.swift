// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "MateNative",
  products: [
    .library(
      name: "MateNative",
      type: .dynamic,
      targets: ["MateNative"]
    )
  ],
  targets: [
    .target(
      name: "CMate",
      path: "Sources/CMate",
      publicHeadersPath: "include"
    ),

    .target(
      name: "MateNative",
      dependencies: ["CMate"]
    )
  ]
)
