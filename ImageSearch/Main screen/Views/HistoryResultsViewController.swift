//
//  HistoryResultsViewController.swift
//  ImageSearch
//
//  Created by Анжелика on 11.09.24.
//

import UIKit

protocol HistoryResultsViewControllerDelegate: AnyObject {
    func didSelectHistoryItem(historyItem: String)
}

final class HistoryResultsViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: HistoryResultsViewControllerDelegate?
    
    private lazy var dataSource = createDataSource()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Keys.historyCellKey)
        tableView.backgroundColor = Constants.Colors.backgroungColor
        view.addSubview(tableView)
        
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return tableView
    }()
    
    // MARK: - ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    private func createDataSource() -> UITableViewDiffableDataSource<Int, String> {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Keys.historyCellKey, for: indexPath)
            cell.backgroundColor = Constants.Colors.backgroungColor
            cell.textLabel?.text = itemIdentifier
            cell.textLabel?.textColor = Constants.Colors.mainTextColor
            return cell
        })
        return dataSource
    }
    
    func updateView(historyItems: [String]) {
        createSnapshot(historyItems: historyItems)
    }
    
    func createSnapshot(historyItems: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(historyItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Keyboard Show and Hide methods
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension HistoryResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = tableView.cellForRow(at: indexPath),
           let historyItem = selectedCell.textLabel?.text {
            delegate?.didSelectHistoryItem(historyItem: historyItem)
        }
    }
}
