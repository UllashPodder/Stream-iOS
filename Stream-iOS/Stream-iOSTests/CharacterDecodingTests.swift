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
    func decodedFixturePage() throws -> PagedResponse<CharacterDTO> {
        let data = try Fixture.load("character_page1")
        let response = try JSONDecoder().decode(PagedResponse<CharacterDTO>.self, from: data)
        return response
    }
//    when several calls to loadNextPageIfNeeded() overlap in time, exactly one fetch reaches the repository.
    @MainActor @Test func loadsFirstPageAndPopulatesCharacters() async throws{
//        arrange
        let mockRepository = MockCharacterRepository()
        mockRepository.result = .success( try decodedFixturePage())
        let sut = CharacterListViewModel(repository: mockRepository)
//        act
        await sut.loadNextPageIfNeeded()
//        assert
        #expect(sut.state == .loaded)
        #expect(sut.characters.count == 20)
        #expect(mockRepository.requestedPages == [1])
    }
    @MainActor @Test func loadsSecondPageAndAppends() async throws{
//        arrange
        let mockRepository = MockCharacterRepository()
        mockRepository.result = .success( try decodedFixturePage())
        let sut = CharacterListViewModel(repository: mockRepository)
//        act
        await sut.loadNextPageIfNeeded()
//        second call
        await sut.loadNextPageIfNeeded()
//        assert
        #expect(sut.state == .loaded)
        #expect(sut.characters.count == 40)
        #expect(mockRepository.requestedPages == [1,2])
    }
    @MainActor @Test func concurrentLoadsRequestPageOnlyOnce() async throws{
//        arrange
        let mockRepository = MockCharacterRepository()
        mockRepository.result = .success( try decodedFixturePage())
        let sut = CharacterListViewModel(repository: mockRepository)
//        act
        await withTaskGroup (of:Void.self) { group in
            for _ in 0..<3 {
                group.addTask { await sut.loadNextPageIfNeeded() }
            }
        }
//        assert
        #expect(sut.state == .loaded)
        #expect(sut.characters.count == 20)
        #expect(mockRepository.requestedPages == [1])
    }
    @MainActor @Test func failedLoadSetsErrorStateAndKeepsCharactersEmpty() async throws {
        let mockRepository = MockCharacterRepository()
        mockRepository.result = .failure(APIError.httpStatus(500))
        let sut = CharacterListViewModel(repository: mockRepository)

        await sut.loadNextPageIfNeeded()

        #expect(sut.characters.isEmpty)
        // assert state is .error
    }
}

