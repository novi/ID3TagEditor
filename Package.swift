// swift-tools-version:5.0
//
//  Package.swift
//  ID3TagEditor
//
//  Created by Fabrizio Duroni on 03/03/2018.
//  2018 Fabrizio Duroni
//

import PackageDescription

let package = Package(
    name: "ID3TagEditor",
    products: [
        .library(name: "ID3TagEditor", targets: ["ID3TagEditor"])
    ],
    targets: [
        .target(
            name: "ID3TagEditor",
            dependencies: [
            ]
        )
    ]
)
