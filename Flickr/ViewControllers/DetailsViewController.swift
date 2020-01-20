//
//  DetailsViewController.swift
//  Flickr
//
//  Created by Kautsya Kanu on 19/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit
import CustomImageView

class DetailsViewController: UIViewController {
	
	// MARK: Elements
    @IBOutlet private weak var flickrLinkButton: UIBarButtonItem!
	@IBOutlet private weak var imageView: CustomImageView!
	@IBOutlet private weak var authorButton: UIButton!
    @IBOutlet private weak var dateTimeLabel: UILabel!
	@IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
	@IBOutlet private weak var dateLabel: UILabel!
	@IBOutlet private weak var descriptionTextView: UITextView!
	
	// MARK: Properties
    let calendar = Calendar.current
	var feedElement: HomeFeedElement!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        setupView()
	}
    
    private func setupView() {
        imageView.setImage(with: feedElement.mediaLink)
        titleLabel.text = feedElement.title
        flickrLinkButton.isEnabled = feedElement.flickrLink != nil
        dateTimeLabel.text = Date().offset(from: feedElement.date) + " ago"
        authorButton.setTitle(feedElement.author, for: .normal)
        dateLabel.text = dateString()
        timeLabel.text = timeString()
        descriptionTextView.attributedText = self.feedElement.attributedDescriptionString
    }
    
    private func dateString() -> String {
        let day = calendar.component(.day, from: feedElement.date)
        let month = calendar.component(.month, from: feedElement.date)
        let year = calendar.component(.year, from: feedElement.date)%100
        return "\(day)/\(month)/\(year)"
    }
    
    private func timeString() -> String {
        let minute = calendar.component(.minute, from: feedElement.date)
        let hour = calendar.component(.hour, from: feedElement.date)
        return "\(hour):\(minute/10)\(minute%10)"
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		switch segue.identifier ?? "" {
		case "presentingFullImageVC":
			let fullImageViewController = segue.destination as! FullImageViewController
            fullImageViewController.imageLink = feedElement.mediaLink
		default:
			break
		}
	}
}

//MARK: IBActions
extension DetailsViewController {
	@IBAction func flickrLinkButtonPressed() {
        open(url: feedElement.flickrLink)
	}
	
	@IBAction func authorButtonPressed() {
        open(url: feedElement.authorLink)
	}
}
