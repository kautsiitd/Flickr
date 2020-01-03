//
//  SearchViewController.swift
//  Flickr
//
//  Created by Kautsya Kanu on 23/11/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: Elements
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: Variables
    private var feed: SearchFeed!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        feed = SearchFeed(delegate: self)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFeed()
    }
    
    @objc
    fileprivate func fetchFeed() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            self?.loader.startAnimating()
            self?.loader.isHidden = false
            self?.feed.fetchFeed(searchText: "Rose")
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.searchElements.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell",
                                                      for: indexPath)
        if let cell = cell as? SearchCollectionViewCell {
            let searchElement = feed.searchElements[indexPath.row]
            cell.setCellWith(searchElement: searchElement)
        }
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30)/2
        let height = width
        return CGSize(width: width, height: height)
    }
}

// MARK: - SearchFeedProtocol
extension SearchViewController: SearchFeedProtocol {
    func feedFetchedSuccessfully() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            self?.loader.stopAnimating()
            self?.loader.isHidden = true
        }
    }
    func feedFetchingFailed(_ error: CustomError) {
        DispatchQueue.main.async { [weak self] in
            self?.loader.stopAnimating()
            self?.loader.isHidden = true
        }
        let retryButton = UIAlertAction(title: "Retry",
                                        style: .default,
                                        handler: { _ in
                                            self.fetchFeed()
        })
        let alertController = UIAlertController(title: error.title,
                                                message: error.description,
                                                preferredStyle: .alert)
        alertController.addAction(retryButton)
        navigationController?.present(alertController,
                                      animated: true,
                                      completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            searchBar.text = "Rose"
        }
        feed.fetchFeed(searchText: searchBar.text ?? "Rose")
        searchBar.endEditing(true)
    }
}
