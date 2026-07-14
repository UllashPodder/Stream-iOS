//
//  APIError.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 14/07/2026.
//

import Foundation
enum APIError: Error, Equatable {
    case invalidResponse
    case httpStatus(Int)
    case decodingFailed
}
