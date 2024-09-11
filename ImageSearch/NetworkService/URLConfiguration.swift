//
//  URLConfiguration.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import Foundation

struct URLConfiguration {
    let baseURL: String
    let accessKey: String
    let path: Path
    let method: HTTPMethod
    
    init(
        baseURL: String = "https://api.unsplash.com",
        accessKey: String = "9rmQ1eV_ZuZSBSu3Mq76sfGeBQqZ42ZR4mFr8oXaq80",
        path: Path,
        method: HTTPMethod
    ) {
        self.baseURL = baseURL
        self.accessKey = accessKey
        self.path = path
        self.method = method
    }
    
    enum Path: String {
        case searchPhotos = "/search/photos"
        case fetchPhotos = "/photos"
        case fetchUsers = "/users"
    }
    
    enum HTTPMethod: String {
        case GET, POST, PUT, PATCH
    }
}
