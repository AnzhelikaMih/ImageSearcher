//
//  UserDefaultsManager.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import Foundation

final class UserDefaultsManager {
    // MARK: - Properties
    private let defaults = UserDefaults.standard
    private let historyKey = Constants.Keys.historyPhotoKey
    
    // MARK: - Public Methods
    func saveSearchQuery(_ query: String) {
        var searchHistory = getSearchHistory()
        if let index = searchHistory.firstIndex(of: query) {
            searchHistory.remove(at: index)
        }
        searchHistory.append(query)
        defaults.set(searchHistory, forKey: historyKey)
    }
    
    func getSearchHistory() -> [String] {
        return defaults.stringArray(forKey: historyKey) ?? []
    }
    
    func getFilteredSearchHistory(for query: String, limit: Int = 5) -> [String] {
        let allHistory = getSearchHistory()
        if query.isEmpty {
            return Array(allHistory.suffix(limit).reversed())
        } else {
            return Array(allHistory.filter { $0.lowercased().contains(query.lowercased()) }.suffix(limit).reversed())
        }
    }
}

