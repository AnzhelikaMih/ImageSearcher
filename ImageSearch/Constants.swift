//
//  Constants.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

enum Constants {
    enum Titles {
        static let appTitle = "ImageSearcher"
        static let okTitle = "OK"
        static let placeholder = "Enter to search"
        static let backButton = "Back"
        static let saveButton = "Save to Gallery"
        static let shareButton = "Share"
    }
    
    enum Colors {
        static let backgroungColor = UIColor.white
        static let secondaryBackgroungColor = UIColor.lightGray
        static let mainTextColor = UIColor.darkText
        static let secondryTextColor = UIColor.darkGray
        static let heartColor = UIColor.red
        static let buttonColor = UIColor.gray
        static let buttonColorLight = UIColor.lightGray
    }
    
    enum SystemImage {
        static let heart = UIImage(systemName: "heart.fill")
        static let searchImage = UIImage(systemName: "photo.on.rectangle.angled")
    }
    
    enum Keys {
        static let historyPhotoKey = "HistoryPhotoKey"
        static let historyCellKey = "HistoryCellKey"
        static let orderBy = "popular"
        static let loadingReuseId = "LoadingView"
    }
    
    enum Font {
        static let neading = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let subheading = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let bodyText = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let likesText = UIFont.systemFont(ofSize: 12, weight: .light)
    }
    
    enum Errors {
        static let queryError = "Search query cannot be empty"
        static let invalidURL = "Invalid URL. Please try again."
        static let unableToComplete = "Unable to complete. Please, check internet connection."
        static let invalidResponse = "Invalid response from the server. Please, try again."
        static let invalidData = "The data received from the server was invalid. Please try again."
    }
}

