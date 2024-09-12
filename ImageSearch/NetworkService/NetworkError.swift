//
//  NetworkError.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

enum NetworkError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    
    var description: String {
        switch self {
        case .invalidURL:
            return Constants.Errors.invalidURL
        case .unableToComplete:
            return Constants.Errors.unableToComplete
        case .invalidResponse:
            return Constants.Errors.invalidResponse
        case .invalidData:
            return Constants.Errors.invalidData
        }
    }
}
