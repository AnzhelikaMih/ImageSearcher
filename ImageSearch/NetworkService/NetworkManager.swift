//
//  NetworkManager.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Properties
    static let shared = NetworkManager()
    private var session = URLSession.shared
    private let cache   = NSCache<NSString, UIImage>()
    
    // MARK: - Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Public Methods
    func searchPhotos(
        query: String,
        page: Int = 1,
        perPage: Int = 30,
        orderBy: String? = Constants.Keys.orderBy,
        completion: @escaping HandlerResponse
    ) {
        let config = URLConfiguration(path: .searchPhotos, method: .GET)

        var components = URLComponents(string: "\(config.baseURL)\(config.path.rawValue)")
        
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "order_by", value: orderBy ?? "relevant"),
            URLQueryItem(name: "client_id", value: config.accessKey)
        ]
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        executeRequest(url: url, completion: completion)
    }
    
    func fetchPhoto(by id: String, completion: @escaping HandlerImage) {
        let config = URLConfiguration(path: .fetchPhotos, method: .GET)
        let urlString = "\(config.baseURL)\(config.path.rawValue)/\(id)?client_id=\(config.accessKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
            
        executeRequest(url: url, completion: completion)
}
    
    func fetchUser(by username: String, completion: @escaping HandlerUser) {
        let config = URLConfiguration(path: .fetchUsers, method: .GET)
        let urlString = "\(config.baseURL)\(config.path.rawValue)/\(username)?client_id=\(config.accessKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        executeRequest(url: url, completion: completion)
    }
    
    func downloadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString else { return }
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }.resume()
    }
    
    // MARK: - Public Methods
    private func executeRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
         session.dataTask(with: url) { data, response, error in
             if error != nil {
                 completion(.failure(.unableToComplete))
                 return
             }
             
             guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                 completion(.failure(.invalidResponse))
                 return
             }
             
             guard let data = data else {
                 completion(.failure(.invalidData))
                 return
             }
              
             do {
                 let decoder = JSONDecoder()
                 let decodedData = try decoder.decode(T.self, from: data)
                 completion(.success(decodedData))
             } catch {
                 completion(.failure(.invalidData))
             }
         }.resume()
     }
}
