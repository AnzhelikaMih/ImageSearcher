//
//  URLConfiguration.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import Foundation

class URLConfiguration {
    let baseURL: String
    let accessKey: String
    let endpoint: Endpoint
    let httpMethod: HTTPMethod
    
    init(
        baseURL: String = "https://api.unsplash.com",
        accessKey: String = "9rmQ1eV_ZuZSBSu3Mq76sfGeBQqZ42ZR4mFr8oXaq80",
        endpoint: Endpoint,
        httpMethod: HTTPMethod
    ) {
        self.baseURL = baseURL
        self.accessKey = accessKey
        self.endpoint = endpoint
        self.httpMethod = httpMethod
    }
    
    enum Endpoint: String {
        case search = "/search/photos"
        case photos = "/photos"
        case users = "/users"
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
    }
}
