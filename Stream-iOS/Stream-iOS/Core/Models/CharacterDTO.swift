//
//  CharacterDTO.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 14/07/2026.
//
import Foundation

struct CharacterDTO: Decodable, Sendable, Identifiable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: String
    let image: URL
}

enum CharacterStatus: String, Decodable, Sendable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = CharacterStatus(rawValue: raw) ?? .unknown
    }
}
