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
	@IBOutlet internal weak var productImageView: CustomImageView!
    @IBOutlet fileprivate weak var imageLoader: UIActivityIndicatorView!
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
        productImageView.setImage(with: feedElement.mediaLink)
		authorNameLabel.text = feedElement.author
		let agoTime = Date().offset(from: feedElement.date)
		dateTimeLabel.text = agoTime == "" ? "Just now" : agoTime + " ago"
	}
}
