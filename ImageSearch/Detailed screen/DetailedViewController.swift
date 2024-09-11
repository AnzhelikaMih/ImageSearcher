//
//  DetailedViewController.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

protocol DetailViewControllerProtocol {
    
}

class DetailViewController: UIViewController {
    var photo: Image
    
    init(photo: Image) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.backgroungColor
    }

}
