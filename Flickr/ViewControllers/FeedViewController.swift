//
//  FeedViewController.swift
//  Flickr
//
//  Created by Kautsya Kanu on 19/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import AVFoundation
import UIKit
import SafariServices

class FeedViewController: UIViewController {
	
	// MARK: Elements
	@IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
	
	// MARK: Variables
	private var feed: HomeFeed!
	private var visibleCellIndexPath: IndexPath!
	private var refreshControl: UIRefreshControl!
    private var layout: MosaicLayout!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        feed = HomeFeed(delegate: self)
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		refreshFeed()
	}
    
    private func setupView() {
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout = collectionView.collectionViewLayout as? MosaicLayout
        layout.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @IBAction private func refreshFeed() {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.layout.invalidateLayout()
            self.feed.fetchFeed()
            self.collectionView.reloadData()
            self.loader.startAnimating()
            self.loader.isHidden = false
        }
    }
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
		coordinator.animate(alongsideTransition: { [weak self] context in
			let firstCellIndexPath = IndexPath(item: 0, section: 0)
			guard let currentCell = self?.collectionView.visibleCells[0] else {
				self?.visibleCellIndexPath = firstCellIndexPath
				return
			}
			self?.visibleCellIndexPath = self?.collectionView.indexPath(for: currentCell) ?? firstCellIndexPath
			context.viewController(forKey: UITransitionContextViewControllerKey.from)
		}, completion: { [weak self] context in
            guard let self = self else {
                return
            }
            self.collectionView.scrollToItem(at: self.visibleCellIndexPath, at: .centeredVertically, animated: true)
		})
		
		guard let flowLayout = collectionView.collectionViewLayout as? MosaicLayout else {
			return
		}
        flowLayout.invalidateLayout()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		switch segue.identifier ?? "" {
		case "pushingDescriptionVC":
			let detailsViewController = segue.destination as! DetailsViewController
			let item = collectionView.indexPathsForSelectedItems?[0].item ?? 0
            detailsViewController.feedElement = feed.feedElements[item]
		default:
			break
		}
	}
}

//MARK: CollectionView
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.feedElements.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as! FeedCollectionViewCell
        cell.feedElement = feed.feedElements[indexPath.item]
		return cell
	}
}

extension FeedViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Range is Screen Height/2
        // and range is distributed to Image Overflow in one Direction = 20
        let range = collectionView.frame.height/40
        for cell in collectionView.visibleCells {
            guard let cell = cell as? FeedCollectionViewCell else {
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
    

// MARK: - MosaicLayoutProtocol
extension FeedViewController: MosaicLayoutProtocol {
	func collectionView(_ collectionView: UICollectionView, heightAt indexPath:IndexPath, for width: CGFloat) -> CGFloat {
        let element = feed.feedElements[indexPath.item]
        let imageSize = CGSize(width: element.imagewidth, height: element.imageHeight)
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let imageRect = AVMakeRect(aspectRatio: imageSize, insideRect: boundingRect)
        return imageRect.height
	}
	
}

// MARK: - HomeFeedProtocol
extension FeedViewController: ApiProtocol {
    func didFetchSuccessfully(for params: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loader.stopAnimating()
            self.loader.isHidden = true
            self.refreshControl.endRefreshing()
            self.layout.invalidateLayout()
            self.collectionView.reloadData()
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    func didFail(with error: CustomError) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loader.stopAnimating()
            self.loader.isHidden = true
            self.refreshControl.endRefreshing()
            self.showRetryAlert(for: error)
        }
    }
    private func showRetryAlert(for error: CustomError) {
        let retry = CustomAlertAction.retry(refreshFeed)
        let alert = CustomAlert(with: error, actions: [retry])
        present(alert, animated: true, completion: nil)
    }
}

extension FeedViewController {
	@IBAction func openFlickrInSafari() {
		guard let url = URL(string: feed?.link ?? "") else {
            showOkAlert(with: .invalidLink)
			return
		}
		let safariViewController = SFSafariViewController(url: url)
		present(safariViewController, animated: true, completion: nil)
	}
}
