//
//  Resources.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

enum Resources {
    enum Colors {
        static let backgroungColor   = UIColor.white
        static let mainTextColor     = UIColor.darkText
        static let secondryTextColor = UIColor.lightText
        static let backgroungSecondryColor = UIColor.clear
    }
    
    enum SystemImage {
        static let heart = UIImage(systemName: "heart.fill")
        static let searchImage = UIImage(systemName: "photo.on.rectangle.angled")
    }
    
    enum Constants {
        static let historyItemKey = "HistoryItemKey"
        static let historyItemCellIdentifier = "HistoryItemCell"
        static let sortedBy = "relevant"
    }
    
    enum Font {
        static let neading = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let subheading = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let bodyText = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let metadata = UIFont.systemFont(ofSize: 12, weight: .light)
    }
}

