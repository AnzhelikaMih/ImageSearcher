//
//  SearchCollectionCell.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

final class SearchCollectionCell: UICollectionViewCell {
    // MARK: - Components
    private let mainImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = Constants.Colors.mainTextColor
        label.font = Constants.Font.medium
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constants.Colors.secondryTextColor
        label.font = Constants.Font.xs
        return label
    }()
    
    private lazy var likesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likesImageView, likesLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var likesImageView: UIImageView = {
        let imageView = UIImageView(image: Constants.SystemImage.heart)
        imageView.tintColor = Constants.Colors.heartColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constants.Colors.secondryTextColor
        label.font = Constants.Font.xs
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(likesStackView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(loadingIndicator)
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    // MARK: - Public functions
    func configureCell(photo: Image) {
        descriptionLabel.text = photo.altDescription ?? "No description"
        dateLabel.text = photo.createdAt?.formatDate()
        likesLabel.text = String(photo.likes ?? 0)
        
        guard let urlPhoto = photo.urls?.regular else { return }
        loadingIndicator.startAnimating()
        
        NetworkManager.shared.downloadImage(from: urlPhoto) { [weak self] image in
            DispatchQueue.main.async {
                self?.mainImageView.image = image
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Private functions
    private func setupConstraints() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likesStackView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            
            likesStackView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 10),
            likesStackView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: likesStackView.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: likesStackView.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
