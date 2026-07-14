//
//  Fixture.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 14/07/2026.
//

import Foundation

enum Fixture {
    enum Error: Swift.Error { case notFound(String) }

    static func load(_ name: String) throws -> Data {
        let bundle = Bundle(for: BundleToken.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw Error.notFound(name)
        }
        return try Data(contentsOf: url)
    }

    private final class BundleToken {}
}
