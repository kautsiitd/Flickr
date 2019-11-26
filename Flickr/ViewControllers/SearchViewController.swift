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
    @IBOutlet fileprivate weak var loader: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    //MARK: Variables
    fileprivate var feed: SearchFeed?
    fileprivate var searchElements: [SearchElement] = []
        
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
        }
        SearchFeed().fetchFeed(self, searchText: "rose")
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchElements.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell",
                                                      for: indexPath)
        if let cell = cell as? SearchCollectionViewCell {
            cell.setCellWith(searchElement: searchElements[indexPath.row])
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
    func feedFetchedSuccessfully(_ feed: SearchFeed) {
        self.feed = feed
        searchElements = feed.searchElements
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            self?.loader.stopAnimating()
            self?.loader.isHidden = true
        }
    }
    func feedFetchingFailed(_ error: NSError?) {
        DispatchQueue.main.async { [weak self] in
            self?.loader.stopAnimating()
            self?.loader.isHidden = true
        }
        let retryButton = UIAlertAction(title: "Retry",
                                        style: .default,
                                        handler: { _ in
                                            self.fetchFeed()
        })
        let alertController = UIAlertController(title: "Error",
                                                message: error?.localizedDescription ?? "Unknown error occured!",
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
        SearchFeed().fetchFeed(self, searchText: searchBar.text ?? "rose")
        searchBar.endEditing(true)
    }
}
