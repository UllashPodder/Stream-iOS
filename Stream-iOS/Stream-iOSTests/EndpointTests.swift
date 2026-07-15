//
//  EndpointTests.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 14/07/2026.
//
import Testing
import Foundation
@testable import Stream_iOS

struct EndpointTests {
    @Test func buildsCharacterPageURL() throws {   // <- throws here
        let url = try #require(Endpoint.characters(page: 3).url)
        #expect(url.absoluteString == "https://rickandmortyapi.com/api/character?page=3")
    }
}
