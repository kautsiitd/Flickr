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
	
	// MARK: Elements
	@IBOutlet private weak var loader: UIActivityIndicatorView!
	
	// MARK: Variables
	private var feed: HomeFeed!
	private var visibleCellIndexPath: IndexPath!
	private var refreshControl: UIRefreshControl!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        feed = HomeFeed(delegate: self)
    }
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return UIStatusBarStyle.lightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.backBarButtonItem?.title = ""
		collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		if let layout = collectionView?.collectionViewLayout as? MasterLayout {
			layout.delegate = self
		}
		refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchFeed), for: UIControl.Event.valueChanged)
		collectionView?.addSubview(refreshControl)
		fetchFeed(normalRefresh: true)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animate(alongsideTransition: { [weak self] context in
			let firstCellIndexPath = IndexPath(item: 0, section: 0)
			guard let currentCell = self?.collectionView?.visibleCells[0] else {
				self?.visibleCellIndexPath = firstCellIndexPath
				return
			}
			self?.visibleCellIndexPath = self?.collectionView?.indexPath(for: currentCell) ?? firstCellIndexPath
			context.viewController(forKey: UITransitionContextViewControllerKey.from)
		}, completion: { [weak self] context in
            guard let self = self else {
                return
            }
			self.collectionView?.scrollToItem(at: self.visibleCellIndexPath, at: .centeredVertically, animated: true)
		})
		
		guard let flowLayout = collectionView?.collectionViewLayout as? MasterLayout else {
			return
		}
		flowLayout.cache = []
		flowLayout.contentHeight = 0
		flowLayout.invalidateLayout()
	}
	
	@objc
	private func fetchFeed(normalRefresh: Bool = false) {
		URLSession.shared.getTasksWithCompletionHandler( { tasks, _, _ in
			for task in tasks {
				task.cancel()
			}
		})
		
		if let layout = (collectionView?.collectionViewLayout as? MasterLayout) {
			layout.cache = []
			layout.contentHeight = 0
		}
        collectionView?.setContentOffset(CGPoint.init(x: 0,
                                                      y: -(collectionView?.contentInset.top ?? 0)),
                                         animated: true)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            if normalRefresh {
                self?.loader.startAnimating()
                self?.loader.isHidden = false
            }
        }
		navigationItem.rightBarButtonItem?.isEnabled = false
        feed.fetchFeed()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		switch segue.identifier ?? "" {
		case "pushingDescriptionVC":
			let detailsViewController = segue.destination as! DetailsViewController
			let item = collectionView?.indexPathsForSelectedItems?[0].item ?? 0
            detailsViewController.feedElement = feed.feedElements[item]
		default:
			break
		}
	}
}

extension MasterCollectionViewController {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.feedElements.count
	}
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MasterCollectionViewCell",
		                                              for: indexPath)
		if let collectionViewCell = cell as? MasterCollectionViewCell {
            collectionViewCell.setCellWith(feedElement: feed.feedElements[indexPath.item])
		}
		return cell
	}
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Range is Screen Height/2
        // and range is distributed to Image Overflow in one Direction = 20
        let range = collectionView.frame.height/40
        for cell in collectionView.visibleCells {
            guard let cell = cell as? MasterCollectionViewCell else {
                continue
            }
            let scrollPos = scrollView.contentOffset.y
            let cellPos = cell.frame.minY
            let cellY = (scrollPos - cellPos)/range
            var newFrame = cell.productImageView.frame
            newFrame.origin = CGPoint(x: 0, y: cellY)
            cell.productImageView.frame = newFrame
        }
    }
}

// MARK: - MasterLayoutDelegate
extension MasterCollectionViewController : MasterLayoutDelegate {
	func collectionView(_ collectionView: UICollectionView,
	                    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return feed.feedElements[indexPath.item].imageHeight
	}
	
}

// MARK: - HomeFeedProtocol
extension MasterCollectionViewController: ApiProtocol {
    func didFetchSuccessfully() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            self?.loader.stopAnimating()
            self?.loader.isHidden = true
            self?.refreshControl.endRefreshing()
            self?.navigationItem.leftBarButtonItem?.isEnabled = true
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func didFail(with error: CustomError) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loader.stopAnimating()
            self.loader.isHidden = true
            self.refreshControl.endRefreshing()
            
            let retry = CustomAlertAction.retry(self.fetchFeed(normalRefresh: true))
            let alert = CustomAlert(with: error, actions: [retry])
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MasterCollectionViewController {
	@IBAction func openFlickrInSafari() {
		guard let url = URL(string: feed?.link ?? "") else {
            showAlert(with: .invalidLink)
			return
		}
		let safariViewController = SFSafariViewController(url: url,
		                                                  entersReaderIfAvailable: true)
		present(safariViewController, animated: true, completion: nil)
	}
	
	@IBAction func refreshFeed() {
		fetchFeed(normalRefresh: true)
	}
}
