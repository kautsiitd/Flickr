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
    private let numberOfColumns = 2
    private let cellSpacing: CGFloat = 10
    private var timer: Timer?
    private var currentQuery: String = "Rose"
    
    //MARK: Calculated
    lazy private var totalSpacing: CGFloat = {
        // +1 because of section insets
        return cellSpacing * (numberOfColumns+1)
    }()
    lazy private var contentWidth: CGFloat = {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }()
    lazy private var cellWidth: CGFloat = {
        return (contentWidth-totalSpacing)/numberOfColumns
    }()

    //MARK:- Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        feed = SearchFeed(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshFeed()
    }

    private func refreshFeed() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loader.startAnimating()
            self.loader.isHidden = false
            self.feed.fetch(for: self.currentQuery, pageNumber: 1)
            self.collectionView?.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "searchToFullImageVC":
            let fullImageViewController = segue.destination as! FullImageViewController
            let cell = sender as! SearchCollectionViewCell
            fullImageViewController.imageLink = cell.searchElement?.imageURL
        default:
            break
        }
    }
}

//MARK:- UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.searchElements.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        cell.searchElement = feed.searchElements[indexPath.row]
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

// MARK:- SearchFeedProtocol
extension SearchViewController: ApiProtocol {
    func didFetchSuccessfully(for params: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loader.stopAnimating()
            self.loader.isHidden = true
            self.collectionView?.reloadData()
        }
    }
    func didFail(with error: CustomError) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loader.stopAnimating()
            self.loader.isHidden = true
            self.showRetryAlert(for: error)
        }
    }
    private func showRetryAlert(for error: CustomError) {
        let retry = CustomAlertAction.retry(self.refreshFeed())
        let alert = CustomAlert(with: error, actions: [retry])
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: {
            _ in
            self.currentQuery = searchBar.text ?? "Rose"
            self.refreshFeed()
        })
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
