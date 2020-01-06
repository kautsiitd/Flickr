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
            self?.feed.fetch(for: "Rose", pageNumber: 1)
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
extension SearchViewController: ApiProtocol {
    func didFetchSuccessfully() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            self?.loader.stopAnimating()
            self?.loader.isHidden = true
        }
    }
    func didFail(with error: CustomError) {
        DispatchQueue.main.async { [weak self] in
            self?.loader.stopAnimating()
            self?.loader.isHidden = true
            
            let retry = CustomAlertAction.retry(self?.fetchFeed())
            let alert = CustomAlert(with: error, actions: [retry])
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            searchBar.text = "Rose"
        }
        let searchString = searchBar.text ?? "Rose"
        feed.fetch(for: searchString, pageNumber: 1)
        searchBar.endEditing(true)
    }
}
