//
//  MainViewControllerProtocol.swift
//  ImageSearch
//
//  Created by Анжелика on 12.09.24.
//

import Foundation

protocol MainViewControllerProtocol: AnyObject {
    func handleError(_ message: String)
    func updateSearch(photos: [Image])
    func updateHistory(queries: [String])
    func startActivityIndicator()
    func stopActivityIndicator()
    func resetView()
    func goToPhotoDetails(photo: Image)
}
