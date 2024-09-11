//
//  SearchCollectionCell.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "SearchCollectionCell"
    
    private let mainImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 15 // Больше закруглений
        image.contentMode = .scaleAspectFill
        image.backgroundColor = Constants.Colors.backgroungSecondryColor.withAlphaComponent(0.8)
        return image
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = Constants.Font.subheading
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .darkGray
        label.font = Constants.Font.metadata
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
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(likesStackView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(loadingIndicator)
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    private func setupConstraints() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likesStackView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Увеличенное изображение
            mainImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            
            // likesStackView под изображением слева
            likesStackView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 10),
            likesStackView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            
            // descriptionLabel ниже likesStackView и выровнено по левому краю
            descriptionLabel.topAnchor.constraint(equalTo: likesStackView.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureCell(photo: Image) {
        descriptionLabel.text = photo.description ?? "No description"
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
}

