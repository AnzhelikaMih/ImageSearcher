//
//  DetailedViewController.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit
import Photos

final class DetailedViewController: UIViewController {
    // MARK: - Properties
    var photo: Image
    
    // MARK: - Components
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.mainTextColor
        label.numberOfLines = 0
        label.font = Constants.Font.medium
        label.textAlignment = .center
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.mainTextColor
        label.font = Constants.Font.small
        label.textAlignment = .center
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Titles.saveButton.uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveImageToGallery), for: .touchUpInside)
        button.backgroundColor = Constants.Colors.buttonColor
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Titles.shareButton.uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        button.backgroundColor = Constants.Colors.buttonColorLight
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = Constants.Colors.secondryTextColor
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    init(photo: Image) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureView()
    }

    // MARK: - Private functions
    private func setupView() {
        view.backgroundColor = Constants.Colors.backgroungColor
        
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        view.addSubview(authorLabel)
        view.addSubview(saveButton)
        view.addSubview(shareButton)
        view.addSubview(loadingIndicator)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -10),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            saveButton.heightAnchor.constraint(equalToConstant: 42),
            
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            shareButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func configureView() {
        if let imageUrl = photo.urls?.regular, let url = URL(string: imageUrl) {
            loadImage(from: url)
        }
        descriptionLabel.text = photo.altDescription ?? "No description available."
        authorLabel.text = "Author: \(photo.user?.name ?? "Unknown")"
    }
    
    private func loadImage(from url: URL) {
        loadingIndicator.startAnimating()
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.loadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - @objc private functions
    @objc private func shareImage() {
        guard let image = imageView.image else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func saveImageToGallery() {
        guard let image = imageView.image else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                let attribute = Alert.Attribute(
                    message: "Permission denied to save images."
                )
                self.presentAlert(with: attribute)
            }
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let attribute = Alert.Attribute(
                message: "Failed to save image."
            )
            presentAlert(with: attribute)
        } else {
            let attribute = Alert.Attribute(
                message: "Image saved to gallery successfully."
            )
            presentAlert(with: attribute)
        }
    }
}
