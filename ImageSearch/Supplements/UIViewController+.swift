//
//  UIViewController+.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

extension UIViewController {
    func presentAlert(with attribute: Alert.Attribute) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: attribute.title,
                message: attribute.message,
                preferredStyle: attribute.preferredStyle
            )
            
            attribute.actions.forEach { alertController.addAction($0) }
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
