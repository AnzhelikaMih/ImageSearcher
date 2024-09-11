//
//  MainPresenter.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit
import Dispatch

protocol MainPresenterProtocol {
    func searchItems(term: String, page: Int, sorderBy: String)
    func resetSearchItems()
    func getHistoryItems(term: String?)
    func goToPhotoDetails(selectedItemIdx: Int)
}

final class MainPresenter: MainPresenterProtocol {
    
    weak private var view: SearchViewControllerProtocol?
    private let networkManager: NetworkManagerProtocol
    var totalPages: Int = 0
    var hasMorePhotos = true
    private var term: String = ""
    private var currentPhotoResponse: Response?
    init() {
        self.networkManager = NetworkManager()
    }
    
    func setView(view: SearchViewControllerProtocol) {
        self.view = view
    }
    
    private func saveTerm(term: String) {
        var allHistoryItems = UserDefaults.standard.stringArray(forKey: Resources.Constants.historyItemKey) ?? []
        if let idx = allHistoryItems.firstIndex(of: term) {
            allHistoryItems.remove(at: idx)
        }
        allHistoryItems.append(term)
        UserDefaults.standard.set(allHistoryItems, forKey: Resources.Constants.historyItemKey)
    }
    
    func searchItems(term: String, page: Int = 1, sorderBy: String = Resources.Constants.orderBy) {
        DispatchQueue.main.async {
            self.view?.startActivityIndicator()
        }
        DispatchQueue.global().async {
            self.saveTerm(term: term)
            self.term = term
            self.networkManager.searchPhotos(query: term, page: page, perPage: 30, orderBy: sorderBy) { result in
                switch result {
                case .success(let response):
                    self.currentPhotoResponse = response
                    self.totalPages = response.totalPages
                    DispatchQueue.main.async {
                        self.view?.stopActivityIndicator()
                        if page == 1 {
                            self.view?.updateSearch(photos: response.results)
                        } else {
                            self.view?.updateSearch(photos: self.currentPhotoResponse?.results ?? [])
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
    
    func resetSearchItems() {
        currentPhotoResponse = nil
        view?.updateSearch(photos: [])
        view?.resetView()
    }
    
    func getHistoryItems(term: String?) {
        guard let term = term else {
            self.view?.updateHistory(queries: [])
            return
        }
        let allHistoryItems = UserDefaults.standard.stringArray(forKey: Resources.Constants.historyItemKey) ?? []
        let historyItems: [String]
        if term == "" {
            historyItems = Array<String>(allHistoryItems.suffix(5).reversed())
        } else {
            historyItems = Array<String>(allHistoryItems.filter { $0.lowercased().contains(term.lowercased()) }.suffix(5).reversed())
        }
        self.view?.updateHistory(queries: historyItems)
    }
    
    func goToPhotoDetails(selectedItemIdx: Int) {
        guard let currentPhotoResponse = currentPhotoResponse else { return }
        let selectedPhoto = currentPhotoResponse.results[selectedItemIdx]
        view?.goToPhotoDetails(photo: selectedPhoto)
    }
    
}

