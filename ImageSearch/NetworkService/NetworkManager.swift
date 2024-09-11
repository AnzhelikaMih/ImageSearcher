//
//  NetworkManager.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Properties
    static let shared = NetworkManager()
    var session = URLSession.shared
    let cache   = NSCache<NSString, UIImage>()
    
    // MARK: - Methods
    func fetchPhotoResponse(
        query: String,
        page: Int? = 1,
        perPage: Int? = 30,
        sorderBy: String? = Resources.Constants.sortedBy,
        completion: @escaping HandlerImageResponse
    ) {
        let urlConfig = URLConfiguration(endpoint: .search, httpMethod: .get)

        let components = URLComponents(string: "\(urlConfig.baseURL)\(urlConfig.endpoint.rawValue)")
        
        guard var components = components else { return }
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page ?? 1)"),
            URLQueryItem(name: "per_page", value: "\(perPage ?? 30)"),
            URLQueryItem(name: "order_by", value: sorderBy ?? "relevant"),
            URLQueryItem(name: "client_id", value: urlConfig.accessKey)
        ]
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(url: url, completion: completion)
    }
    
    func fetchPhoto(by id: String, completion: @escaping HandlerImage) {
        let urlConfig = URLConfiguration(endpoint: .photos, httpMethod: .get)
        let urlString = "\(urlConfig.baseURL)\(urlConfig.endpoint.rawValue)/\(id)?client_id=\(urlConfig.accessKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
            
        performRequest(url: url, completion: completion)
}
    
    func fetchUser(by username: String, completion: @escaping HandlerUser) {
        let urlConfig = URLConfiguration(endpoint: .users, httpMethod: .get)
        let urlString = "\(urlConfig.baseURL)\(urlConfig.endpoint.rawValue)/\(username)?client_id=\(urlConfig.accessKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(url: url, completion: completion)
    }
    
    func downloadImage(from url: String?, completed: @escaping (UIImage?) -> Void) {
        guard let url = url else { return }
        let cacheKey = NSString(string: url)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        guard let url = URL(string: url) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
    
    private func performRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
         let task = URLSession.shared.dataTask(with: url) { data, response, error in
             if let _ = error {
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
         }
         task.resume()
     }
}
