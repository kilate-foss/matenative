// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "KilateNative",
  products: [
    .library(
      name: "KilateNative",
      type: .dynamic,
      targets: ["KilateNative"]
    )
  ],
  targets: [
    .target(
      name: "CKilate",
      path: "Sources/CKilate",
      publicHeadersPath: "include"
    ),

    .target(
      name: "KilateNative",
      dependencies: ["CKilate"]
    )
  ]
)
