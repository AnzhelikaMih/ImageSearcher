//
//  NetworkManagerProtocol.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

// MARK: - NetworkManagerProtocol
protocol NetworkManagerProtocol {
    typealias HandlerResponse = (Result<Response, NetworkError>) -> Void
    typealias HandlerImage = (Result<Image, NetworkError>) -> Void
    typealias HandlerUser = (Result<User, NetworkError>) -> Void
    
    func searchPhotos(query: String, page: Int, perPage: Int, orderBy: String?, completion: @escaping HandlerResponse)
    func fetchPhoto(by id: String, completion: @escaping HandlerImage)
    func fetchUser(by username: String, completion: @escaping HandlerUser)
}
