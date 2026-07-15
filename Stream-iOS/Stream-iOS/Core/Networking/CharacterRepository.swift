//
//  CharacterRepository.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 14/07/2026.
//

protocol CharacterRepository: Sendable {
    func fetchCharacters(page: Int) async throws -> PagedResponse<CharacterDTO>
}
