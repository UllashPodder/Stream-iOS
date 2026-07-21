//
//  CharacterListState.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 20/07/2026.
//
enum CharacterListState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}
