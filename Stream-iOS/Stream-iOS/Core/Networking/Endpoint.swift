//
//  Endpoint.swift
//  Stream-iOS
//
//  Created by Ullash Podder on 14/07/2026.
//

import Foundation

struct Endpoint{
    let path : String
    let queryItems : [URLQueryItem]
    var url:URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        components.path = "/api" + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url
    }
}
extension Endpoint {
    static func characters(page:Int) -> Endpoint{
        Endpoint(path: "/character", queryItems: [URLQueryItem(name: "page", value: "\(page)")])
    }
}
