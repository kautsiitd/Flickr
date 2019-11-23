//
//  MasterCollectionViewCell.swift
//  Flickr
//
//  Created by Kautsya Kanu on 19/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit

class MasterCollectionViewCell: UICollectionViewCell {
	
	// MARK: Elements
	@IBOutlet internal weak var productImageView: UIImageView!
	@IBOutlet fileprivate weak var gradientView: GradientView!
	@IBOutlet fileprivate weak var authorNameLabel: UILabel!
	@IBOutlet fileprivate weak var dateTimeLabel: UILabel!
	
	// MARK: Properties
	fileprivate var feedElement: FeedElement?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		gradientView.layer.shouldRasterize = true
		gradientView.layer.rasterizationScale = UIScreen.main.scale
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		feedElement = nil
		productImageView.image = #imageLiteral(resourceName: "Placeholder")
		authorNameLabel.text = ""
		dateTimeLabel.text = ""
	}
}

extension MasterCollectionViewCell {
	func setCellWith(feedElement: FeedElement) {
		self.feedElement = feedElement
		if let imageURL = URL(string: feedElement.mediaLink) {
			productImageView.getImageWith(imageURL, placeHolderImage:
                #imageLiteral(resourceName: "Placeholder"), completion: { [weak self] image, url, fetchedImageType in
				guard let feedElement = self?.feedElement else {
					self?.productImageView.stopLoader()
					self?.productImageView.image = #imageLiteral(resourceName: "Placeholder")
					return
				}
				if url.absoluteString == feedElement.mediaLink {
					guard let image = image else {
						DispatchQueue.main.async {
							self?.productImageView.stopLoader()
							self?.productImageView.image = #imageLiteral(resourceName: "Placeholder")
						}
						return
					}
					self?.handleImageTransition(image: image,
											   fetchedImageType: fetchedImageType)
				}
			})
		}
		authorNameLabel.text = feedElement.author
		let agoTime = Date().offset(from: feedElement.date)
		dateTimeLabel.text = agoTime == "" ? "Just now" : agoTime + " ago"
	}
	
	fileprivate func handleImageTransition(image: UIImage, fetchedImageType: FetchedImageType) {
		switch fetchedImageType {
		case .cache:
			DispatchQueue.main.async { [weak self] in
				self?.productImageView.stopLoader()
				self?.productImageView.image = image
			}
		case .downloaded:
			productImageView.animate(image: image,
			                         withAnimation: .transitionCrossDissolve)
		}
	}
}
