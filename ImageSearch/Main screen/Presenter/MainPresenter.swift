//
//  MainPresenter.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

final class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    weak private var view: SearchViewControllerProtocol?
    private let networkService: NetworkManagerProtocol
    private var photoSearchResponse: Response?
    
    private(set) var totalPages: Int = 0
    private(set) var hasMorePhotos = true
    private var term: String = .init()
    
    
    // MARK: - Initializaton
    init() {
        self.networkService = NetworkManager()
    }
    
    // MARK: - Public functions
    func attachView(view: SearchViewControllerProtocol) {
        self.view = view
    }
    
    func performPhotoSearch(query: String,
                            page: Int = 1,
                            orderBy: String = Constants.Keys.orderBy
    ) {
        DispatchQueue.main.async {
            self.view?.startActivityIndicator()
        }
        
        DispatchQueue.global().async {
            self.saveItemsToSeacrhHistory(term: query)
            self.term = query
            self.networkService.searchPhotos(query: self.term, page: page, perPage: 30, orderBy: orderBy) { result in
                switch result {
                case .success(let response):
                    self.photoSearchResponse = response
                    self.totalPages = response.totalPages
                    
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        if page == 1 {
                            self.view?.updateSearch(photos: response.results)
                        } else {
                            self.view?.updateSearch(photos: self.photoSearchResponse?.results ?? [])
                        }
                        self.hasMorePhotos = page < self.totalPages
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        self.view?.handleError(error.description)
                    }
                }
            }
        }
    }
    
    func resetPhotoSearch() {
        photoSearchResponse = nil
        view?.updateSearch(photos: [])
        view?.resetView()
    }
    
    func getPreviousResults(term: String?) {
        guard let term = term else {
            self.view?.updateHistory(queries: [])
            return
        }
        let allHistoryItems = UserDefaults.standard.stringArray(forKey: Constants.Keys.historyPhotoKey) ?? []
        let historyItems: [String]
        if term == "" {
            historyItems = Array<String>(allHistoryItems.suffix(5).reversed())
        } else {
            historyItems = Array<String>(allHistoryItems.filter { $0.lowercased().contains(term.lowercased()) }.suffix(5).reversed())
        }
        self.view?.updateHistory(queries: historyItems)
    }
    
    func goToPhotoDetails(selectedIndex: Int) {
        guard let currentPhotoResponse = photoSearchResponse else { return }
        let selectedPhoto = currentPhotoResponse.results[selectedIndex]
        view?.goToPhotoDetails(photo: selectedPhoto)
    }
    
    private func saveItemsToSeacrhHistory(term: String) {
        var photosToHistory = UserDefaults.standard.stringArray(forKey: Constants.Keys.historyPhotoKey) ?? []
        if let index = photosToHistory.firstIndex(of: term) {
            photosToHistory.remove(at: index)
        }
        photosToHistory.append(term)
        UserDefaults.standard.set(photosToHistory, forKey: Constants.Keys.historyPhotoKey)
    }
}

