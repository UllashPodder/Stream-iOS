//
//  PagedResponse.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 14/07/2026.
//

import Foundation
struct PagedResponse<T: Decodable & Sendable>: Decodable, Sendable {
    let info: PageInfo
    let results: [T]
}

struct PageInfo: Decodable, Sendable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}

