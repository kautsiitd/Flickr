//
//  MasterCollectionViewCell.swift
//  Flickr
//
//  Created by Kautsya Kanu on 19/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit
import CustomImageView

class FeedCollectionViewCell: UICollectionViewCell {
	
	// MARK: Elements
	@IBOutlet internal weak var productImageView: CustomImageView!
	@IBOutlet private weak var gradientView: GradientView!
	@IBOutlet private weak var authorNameLabel: UILabel!
	@IBOutlet private weak var dateTimeLabel: UILabel!
	
	// MARK: Properties
    var feedElement: HomeFeedElement? {
        didSet { updateCell() }
    }
	
	override func awakeFromNib() {
		super.awakeFromNib()
        layer.cornerRadius = 5
		gradientView.layer.shouldRasterize = true
		gradientView.layer.rasterizationScale = UIScreen.main.scale
	}
	
	override func prepareForReuse() {
		feedElement = nil
	}
}

extension FeedCollectionViewCell {
	private func updateCell() {
        guard let feedElement = feedElement else {
            defaultCell()
            return
        }
        productImageView.setImage(with: feedElement.mediaLink)
		authorNameLabel.text = feedElement.author
		let agoTime = Date().offset(from: feedElement.date)
		dateTimeLabel.text = agoTime == "" ? "Just now" : agoTime + " ago"
	}
    private func defaultCell() {
        productImageView.image = #imageLiteral(resourceName: "Placeholder.png")
        authorNameLabel.text = ""
        dateTimeLabel.text = ""
    }
}
