//
//  Response.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

struct Response: Codable {
    let total: Int
    let totalPages: Int
    let results: [Image]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
