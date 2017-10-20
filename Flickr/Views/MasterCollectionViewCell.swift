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
	
	override func awakeFromNib() {
		super.awakeFromNib()
		gradientView.layer.shouldRasterize = true
		gradientView.layer.rasterizationScale = UIScreen.main.scale
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		productImageView.image = #imageLiteral(resourceName: "Placeholder")
		authorNameLabel.text = ""
		dateTimeLabel.text = ""
	}
}

extension MasterCollectionViewCell {
	func setCellWith(feedElement: FeedElement) {
		let imageURL = URL(string: feedElement.mediaLink)
		productImageView.setImageWithUrl(imageURL,
		                                 placeHolderImage: #imageLiteral(resourceName: "Placeholder"))
		authorNameLabel.text = feedElement.author
		dateTimeLabel.text = Date().offset(from: feedElement.date) + " ago"
	}
	
	//	func animateWith(relativePosition: CGFloat) {
	//		let totalMovement = CGFloat(72)
	//		productImageView.frame.origin.y = -totalMovement * relativePosition
	//	}
}
