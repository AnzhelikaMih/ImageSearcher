//
//  NetworkError.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please try again."
        case .unableToComplete:
            return "Unable to complete. Please, check internet connection"
        case .invalidResponse:
            return "Invalid response from the server. Please, try again."
        case .invalidData:
            return "The data received from the server was invalid. Please try again."
        }
    }
}
