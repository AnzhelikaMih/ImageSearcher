//
//  Alert.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

final class Alert {
    // MARK: - Attribute
    struct Attribute {
        let title: String?
        let message: String?
        let actions: [UIAlertAction]
        let preferredStyle: UIAlertController.Style
        
        init(
            title: String? = nil,
            message: String? = nil,
            actions: [UIAlertAction] = [],
            preferredStyle: UIAlertController.Style = .alert
        ) {
            self.title = title
            self.message = message
            self.actions = actions.isEmpty ? [createAction(title: Constants.Titles.okTitle, style: .default)] : actions
            self.preferredStyle = preferredStyle
        }
    }
    
    // MARK: - Methods
    /// Creates a UIAlertAction with the given title, style, and handler.
        /// - Parameters:
        ///   - title: The title of the action.
        ///   - style: The style of the action.
        ///   - handler: The handler to execute when the action is triggered.
        /// - Returns: A configured UIAlertAction.
    static func createAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
}
