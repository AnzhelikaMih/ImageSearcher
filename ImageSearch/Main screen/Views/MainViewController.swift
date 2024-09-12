//
//  MainViewController.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

final class MainViewController: UIViewController, MainViewControllerProtocol {
    // MARK: - Properties
    var presenter: MainPresenter
    private var photos: [Image] = []
    private var page = 1
    
    // MARK: - Components
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var colleсtionView = UICollectionView(frame: view.bounds, collectionViewLayout: createTwoColumnsLayout())
    
    private lazy var searchController: UISearchController = {
        let searchResultsController = HistoryResultsViewController()
        searchResultsController.delegate = self
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.tintColor = Constants.Colors.mainTextColor
        return searchController
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.SystemImage.searchImage
        imageView.tintColor = Constants.Colors.secondaryBackgroungColor.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.loadView(controller: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private functions
    private func setupView() {
        view.backgroundColor = Constants.Colors.backgroungColor
        setupCollectionView()
        setupActivityIndicator()
        setupNavigationBar()
        setupSearchController()
        setupImageView()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(colleсtionView)
        
        colleсtionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: Constants.Keys.reuseIdentifierCell)
        colleсtionView.register(LoadingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Constants.Keys.loadingReuseId)
        colleсtionView.delegate = self
        colleсtionView.dataSource = self
        colleсtionView.alwaysBounceVertical = true
        
        colleсtionView.backgroundColor = Constants.Colors.backgroungColor
        colleсtionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colleсtionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            colleсtionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            colleсtionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            colleсtionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Constants.Titles.placeholder
        searchController.searchBar.delegate = self
        searchController.showsSearchResultsController = true
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.Titles.appTitle
        navigationItem.backButtonTitle = Constants.Titles.backButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func createTwoColumnsLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 16
        let numberOfColumns: CGFloat = 2
        
        let totalHorizontalSpacing = padding * numberOfColumns
        let availableWidth = width - totalHorizontalSpacing - padding
        let itemWidth = availableWidth / numberOfColumns
        
        let itemHeight: CGFloat = 270
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return layout
    }
    
    private func searchItems(term: String) {
        searchController.isActive = false
        presenter.performPhotoSearch(query: term)
        searchController.searchBar.text = term
    }
    
    // MARK: - Search methods
    func updateSearch(photos: [Image]) {
        if page == 1 {
            self.photos = photos
        } else {
            self.photos.append(contentsOf: photos)
        }
        DispatchQueue.main.async {
            self.colleсtionView.reloadData()
        }
    }
    
    // MARK: - Public functions
    func handleError(_ message: String) {
        let attribute = Alert.Attribute(
            message: message)
        presentAlert(with: attribute)
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func resetView() {
        searchController.searchBar.text = nil
        navigationItem.leftBarButtonItem = nil
    }
    
    func updateHistory(queries: [String]) {
        if let searchResultsController = searchController.searchResultsController as? HistoryResultsViewController {
            searchResultsController.updateView(historyItems: queries)
        }
    }
    
    func goToPhotoDetails(photo: Image) {
        let detailedVC = DetailedViewController(photo: photo)
        navigationController?.pushViewController(detailedVC, animated: true)
    }
}

// MARK: - CollectionView's extensions
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Keys.reuseIdentifierCell, for: indexPath) as! SearchCollectionCell
        cell.configureCell(photo: photos[indexPath.item])
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            guard presenter.hasMorePhotos else { return }
            
            page += 1
            presenter.performPhotoSearch(query: searchController.searchBar.text ?? "", page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.Keys.loadingReuseId, for: indexPath) as! LoadingView
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return presenter.hasMorePhotos ? CGSize(width: collectionView.bounds.width, height: 50) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.goToPhotoDetails(selectedIndex: indexPath.item)
    }
}

// MARK: - Search's extensions
extension MainViewController: HistoryResultsViewControllerDelegate {
    func didSelectHistoryItem(historyItem: String) {
        searchItems(term: historyItem)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            presenter.getPreviousResults(term: searchController.searchBar.text ?? "")
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        imageView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            searchItems(term: term)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDone()
        imageView.isHidden = false
    }
    
    // MARK: - @objc methods
    @objc func searchDone() {
        presenter.resetPhotoSearch()
        imageView.isHidden = false
    }
}
