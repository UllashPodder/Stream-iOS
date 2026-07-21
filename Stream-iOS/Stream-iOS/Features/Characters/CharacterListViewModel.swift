//
//  CharacterListViewModel.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 20/07/2026.
//

import Foundation

@MainActor
@Observable
final class CharacterListViewModel {
    private(set) var characters: [CharacterDTO] = []
    private(set) var state: CharacterListState = .idle

    private let repository: CharacterRepository
    private var currentPage = 0
    private var totalPages = Int.max      // unknown until first response
    private var isLoading = false          // the dedupe guard

    init(repository: CharacterRepository) {
        self.repository = repository
    }

    func loadNextPageIfNeeded() async {
        // Guard 1: don't start a fetch while one is running
        guard !isLoading else { return }
        // Guard 2: don't fetch past the last page
        guard currentPage < totalPages else { return }

        isLoading = true
        state = .loading
        let nextPage = currentPage + 1

        do {
            let response = try await repository.fetchCharacters(page: nextPage)
            characters.append(contentsOf: response.results)
            currentPage = nextPage
            totalPages = response.info.pages
            state = .loaded
        } catch {
            state = .error("Could not load characters.")
        }

        isLoading = false
    }
}
