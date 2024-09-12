//
//  String+.swift
//  ImageSearch
//
//  Created by Анжелика on 12.09.24.
//

import Foundation

extension String {
    func formatDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        if let date = isoFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        }
        return "Invalid date"
    }
}
