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
	@IBOutlet fileprivate weak var productImageView: UIImageView!
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
		self.feedElement = nil
		productImageView.image = #imageLiteral(resourceName: "Placeholder")
		authorNameLabel.text = ""
		dateTimeLabel.text = ""
	}
}

extension MasterCollectionViewCell {
	func setCellWith(feedElement: FeedElement) {
		self.feedElement = feedElement
		if let imageURL = URL(string: feedElement.mediaLink) {
			self.productImageView.getImageWith(imageURL,
			                                   placeHolderImage: #imageLiteral(resourceName: "Placeholder"),
			                                   completion: { image, url, fetchedImageType in
												guard let feedElement = self.feedElement else {
													self.productImageView.image = #imageLiteral(resourceName: "Placeholder")
													return
												}
												if url.absoluteString == feedElement.mediaLink {
													guard let image = image else {
														DispatchQueue.main.async {
															self.productImageView.image = #imageLiteral(resourceName: "Placeholder")
														}
														return
													}
													self.handleImageTransition(image: image,
													                           fetchedImageType: fetchedImageType)
												}
			})
		}
		authorNameLabel.text = feedElement.author
		dateTimeLabel.text = Date().offset(from: feedElement.date) + " ago"
	}
	
	fileprivate func handleImageTransition(image: UIImage, fetchedImageType: FetchedImageType) {
		switch fetchedImageType {
		case .cache:
			DispatchQueue.main.async {
				self.productImageView.image = image
			}
		case .downloaded:
			productImageView.animate(image: image,
			                         withAnimation: .transitionCrossDissolve,
			                         completion: { _ in })
		}
	}
	
	//	func animateWith(relativePosition: CGFloat) {
	//		let totalMovement = CGFloat(72)
	//		productImageView.frame.origin.y = -totalMovement * relativePosition
	//	}
}
