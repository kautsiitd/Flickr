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
            self.feed.fetchFirstPage(for: self.currentQuery)
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

//MARK:- Collection View
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var searchCount = feed.searchElements.count
        if feed.currentPage < feed.totalPages && searchCount != 0 { searchCount += 1 }
        return searchCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < feed.searchElements.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
            let cellData = feed.searchElements[indexPath.row]
            cell.searchElement = cellData
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoaderCollectionViewCell", for: indexPath) as! LoaderCollectionViewCell
            return cell
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == feed.searchElements.count {
            feed.fetchNextPage()
        }
    }
}

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
        let retry = CustomAlertAction.retry(self.refreshFeed)
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
