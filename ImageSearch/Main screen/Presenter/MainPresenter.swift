//
//  MainPresenter.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

final class MainPresenter: MainPresenterProtocol {
    // MARK: - Properties
    weak private var controller: MainViewControllerProtocol?
    private let networkService: NetworkManagerProtocol
    private let userDefaultsManager: UserDefaultsManager
    private var photoSearchResponse: Response?
    
    private(set) var totalPages: Int = 0
    private(set) var hasMorePhotos = true
    private var term: String = .init()
    
    
    // MARK: - Initializaton
    init() {
        self.networkService = NetworkManager()
        self.userDefaultsManager = UserDefaultsManager()
    }
    
    // MARK: - Public functions
    func loadView(controller: MainViewControllerProtocol) {
        self.controller = controller
    }
    
    func performPhotoSearch(query: String,
                            page: Int = 1,
                            orderBy: String = Constants.Keys.orderBy
    ) {
        DispatchQueue.main.async {
            self.controller?.startActivityIndicator()
        }
        
        DispatchQueue.global().async {
            self.userDefaultsManager.saveSearchQuery(query)
            self.term = query
            self.networkService.searchPhotos(query: self.term, page: page, perPage: 30, orderBy: orderBy) { result in
                switch result {
                case .success(let response):
                    self.photoSearchResponse = response
                    self.totalPages = response.totalPages
                    
                    DispatchQueue.main.async {
                        self.controller?.stopActivityIndicator()
                        if page == 1 {
                            self.controller?.updateSearch(photos: response.results)
                        } else {
                            self.controller?.updateSearch(photos: self.photoSearchResponse?.results ?? [])
                        }
                        self.hasMorePhotos = page < self.totalPages
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.controller?.stopActivityIndicator()
                        self.controller?.handleError(error.description)
                    }
                }
            }
        }
    }
    
    func resetPhotoSearch() {
        photoSearchResponse = nil
        controller?.updateSearch(photos: [])
        controller?.resetView()
    }
    
    func getPreviousResults(term: String?) {
        let historyItems = userDefaultsManager.getFilteredSearchHistory(for: term ?? .init())
        controller?.updateHistory(queries: historyItems)
    }
    
    func goToPhotoDetails(selectedIndex: Int) {
        guard let currentPhotoResponse = photoSearchResponse else { return }
        let selectedPhoto = currentPhotoResponse.results[selectedIndex]
        controller?.goToPhotoDetails(photo: selectedPhoto)
    }
}
