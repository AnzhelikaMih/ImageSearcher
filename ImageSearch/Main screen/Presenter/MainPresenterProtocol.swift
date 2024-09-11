//
//  MainPresenterProtocol.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

protocol MainPresenterProtocol {
    func performPhotoSearch(query: String, page: Int, orderBy: String)
    func resetPhotoSearch()
    func getPreviousResults(term: String?)
    func goToPhotoDetails(selectedIndex: Int)
}
