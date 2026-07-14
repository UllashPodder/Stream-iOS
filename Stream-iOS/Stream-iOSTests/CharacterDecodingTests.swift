//
//  CharacterDecodingTests.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 14/07/2026.
//

import Testing
import Foundation
@testable import Stream_iOS

struct CharacterDecodingTests {

    @Test func decodesPagedResponseFromFixture() throws {
        let data = try Fixture.load("character_page1")
        let response = try JSONDecoder().decode(PagedResponse<CharacterDTO>.self, from: data)

        #expect(response.info.count == 826)
        #expect(response.info.pages == 42)
        #expect(response.results.count == 20)
        #expect(response.info.next != nil)
        #expect(response.info.prev == nil)
    }

    @Test func decodesFirstCharacterCorrectly() throws {
        let data = try Fixture.load("character_page1")
        let response = try JSONDecoder().decode(PagedResponse<CharacterDTO>.self, from: data)
        let rick = try #require(response.results.first)

        #expect(rick.id == 1)
        #expect(rick.name == "Rick Sanchez")
        #expect(rick.status == .alive)
        #expect(rick.species == "Human")
        #expect(rick.image.absoluteString.hasSuffix("/avatar/1.jpeg"))
    }

    @Test func decodesUnknownStatusAsFallback() throws {
        let json = #"{"id":1,"name":"X","status":"Martian","species":"Y","gender":"Male","image":"https://a.com/1.jpeg"}"#
        let dto = try JSONDecoder().decode(CharacterDTO.self, from: Data(json.utf8))

        #expect(dto.status == .unknown)
    }
}

