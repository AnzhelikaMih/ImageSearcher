//
//  MainViewController.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func handleError(_ message: String)
    func updateSearch(photos: [Image])
    func updateHistory(queries: [String])
    func startActivityIndicator()
    func stopActivityIndicator()
    func resetView()
    func goToPhotoDetails(photo: Image)
}

class SearchViewController: UIViewController, SearchViewControllerProtocol {
    // MARK: - Properties
    var presenter: MainPresenter
    private var photos: [Image] = []
    private var page = 1
    
    // MARK: - Components
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var colletionView = UICollectionView(frame: view.bounds, collectionViewLayout: createTwoColumnFlowLayout())
    
    private lazy var searchController: UISearchController = {
        let searchResultsController = SearchResultsViewController()
        searchResultsController.delegate = self
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.tintColor = Resources.Colors.mainTextColor
        return searchController
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Resources.SystemImage.searchImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.setView(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup view methods
    private func setupView() {
        view.backgroundColor = Resources.Colors.backgroungColor
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
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(colletionView)
        
        colletionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.reuseIdentifier)
        colletionView.register(LoadingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingView.reuseId)
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.alwaysBounceVertical = true
        
        colletionView.backgroundColor = Resources.Colors.backgroungColor
        colletionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colletionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            colletionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            colletionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            colletionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Enter to search"
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
        navigationItem.title = "ImageSearcher"
        navigationItem.backButtonTitle = "Back"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func createTwoColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 16
        let minimumItemSpacing: CGFloat = 10
        let numberOfColumns = 2
        
        let totalHorizontalPadding = padding * 2
        let totalSpacing = minimumItemSpacing * CGFloat(numberOfColumns - 1)
        let availableWidth = width - totalHorizontalPadding - totalSpacing
        let itemWidth = availableWidth / CGFloat(numberOfColumns)
        
        let itemHeight: CGFloat = 270
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumInteritemSpacing = minimumItemSpacing
        flowLayout.minimumLineSpacing = minimumItemSpacing
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return flowLayout
    }
    
    // MARK: - Search methods
    func updateSearch(photos: [Image]) {
        if page == 1 {
            self.photos = photos
        } else {
            self.photos.append(contentsOf: photos)
        }
        DispatchQueue.main.async {
            self.colletionView.reloadData()
        }
    }
    
    private func searchItems(term: String) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(searchDone))
        searchController.isActive = false
        presenter.searchItems(term: term)
        searchController.searchBar.text = term
    }
    
    // MARK: - @objc methods
    @objc func searchDone() {
        presenter.resetSearchItems()
        imageView.isHidden = false
    }
    
    // MARK: - methods
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
        if let searchResultsController = searchController.searchResultsController as? SearchResultsViewController {
            searchResultsController.updateView(historyItems: queries)
        }
    }
    
    func goToPhotoDetails(photo: Image) {
        let detailVC = DetailViewController(photo: photo)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - CollectionView's extensions
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.reuseIdentifier, for: indexPath) as! SearchCollectionCell
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
            presenter.searchItems(term: searchController.searchBar.text ?? "", page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingView.reuseId, for: indexPath) as! LoadingView
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return presenter.hasMorePhotos ? CGSize(width: collectionView.bounds.width, height: 50) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.goToPhotoDetails(selectedItemIdx: indexPath.item)
    }
}

// MARK: - Search's extensions
extension SearchViewController: SearchResultsViewControllerDelegate {
    func didSelectHistoryItem(historyItem: String) {
        searchItems(term: historyItem)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            presenter.getHistoryItems(term: searchController.searchBar.text ?? "")
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
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
}
