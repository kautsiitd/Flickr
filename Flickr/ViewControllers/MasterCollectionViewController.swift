//
//  MasterCollectionViewController.swift
//  Flickr
//
//  Created by Kautsya Kanu on 19/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit
import SafariServices

class MasterCollectionViewController: UICollectionViewController {
	
	// MARK: Variables
	fileprivate var feed: GetFeed?
	fileprivate var feedElements: [FeedElement] = []
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return UIStatusBarStyle.lightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.backBarButtonItem?.title = ""
		collectionView?.contentInset = UIEdgeInsets(top: 13, left: 10, bottom: 10, right: 10)
		if let layout = collectionView?.collectionViewLayout as? MasterLayout {
			layout.delegate = self
		}
		
		GetFeed().fetchFeed(self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		switch segue.identifier ?? "" {
		case "pushingDescriptionVC":
			let detailsViewController = segue.destination as! DetailsViewController
			let item = self.collectionView?.indexPathsForSelectedItems?[0].item ?? 0
			detailsViewController.feedElement = feedElements[item]
		default:
			break
		}
	}
}

extension MasterCollectionViewController {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return feedElements.count
	}
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MasterCollectionViewCell",
		                                              for: indexPath)
		if let collectionViewCell = cell as? MasterCollectionViewCell {
			collectionViewCell.setCellWith(feedElement: feedElements[indexPath.item])
		}
		return cell
	}
}

// MARK: - MasterLayoutDelegate
extension MasterCollectionViewController : MasterLayoutDelegate {
	func collectionView(_ collectionView: UICollectionView,
	                    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
		return feedElements[indexPath.item].imageHeight
	}
	
}

// MARK: - GetFeedProtocol
extension MasterCollectionViewController: GetFeedProtocol {
	func feedFetchedSuccessfully(_ feed: GetFeed) {
		// remove loader
		self.feed = feed
		self.feedElements = feed.feedElements
		self.collectionView?.reloadData()
	}
	func feedFetchingFailed(_ error: NSError?) {
		// remove loader
		let retryButton = UIAlertAction(title: "Retry",
		                                style: .default,
		                                handler: { _ in
											// showLoader
											GetFeed().fetchFeed(self)
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

extension MasterCollectionViewController {
	@IBAction func openFlickrInSafari() {
		guard let url = URL(string: feed?.link ?? "") else {
			let alertController = UIAlertController(title: "Error",
			                                        message: "Link is not Working!!",
			                                        preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK",
			                                        style: .cancel,
			                                        handler: nil))
			navigationController?.present(alertController,
			                              animated: true,
			                              completion: nil)
			return
		}
		let safariViewController = SFSafariViewController(url: url,
		                                                  entersReaderIfAvailable: true)
		navigationController?.present(safariViewController,
		                              animated: true,
		                              completion: nil)
	}
	
	
	@IBAction func refreshFeed() {
		GetFeed().fetchFeed(self)
	}
}
