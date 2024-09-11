//
//  NetworkManagerProtocol.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

// MARK: - NetworkManagerProtocol
protocol NetworkManagerProtocol {
    typealias HandlerImageResponse = (Result<ImageResponse, NetworkError>) -> Void
    typealias HandlerImage = (Result<Image, NetworkError>) -> Void
    typealias HandlerUser = (Result<User, NetworkError>) -> Void
    
    func fetchPhotoResponse(query: String, page: Int?, perPage: Int?, sorderBy: String?, completion: @escaping HandlerImageResponse)
    func fetchPhoto(by id: String, completion: @escaping HandlerImage)
    func fetchUser(by username: String, completion: @escaping HandlerUser)
}
