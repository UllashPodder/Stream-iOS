//
//  MockCharacterRepository.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 14/07/2026.
//
//import Testing
//import Foundation
@testable import Stream_iOS

final class MockCharacterRepository: CharacterRepository, @unchecked Sendable {
    var result: Result<PagedResponse<CharacterDTO>, Error> = .failure(APIError.invalidResponse)
    private(set) var requestedPages: [Int] = []

    func fetchCharacters(page: Int) async throws -> PagedResponse<CharacterDTO> {
        requestedPages.append(page)
        try await Task.sleep(for: .milliseconds(50))
        return try result.get()
    }
}
