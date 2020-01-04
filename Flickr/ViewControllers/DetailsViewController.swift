//
//  DetailsViewController.swift
//  Flickr
//
//  Created by Kautsya Kanu on 19/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {
	
	// MARK: Elements
	@IBOutlet fileprivate weak var imageView: CustomImageView!
	@IBOutlet fileprivate weak var titleLabel: UILabel!
	@IBOutlet fileprivate weak var flickrLinkButton: UIBarButtonItem!
	@IBOutlet fileprivate weak var dateTimeLabel: UILabel!
	@IBOutlet fileprivate weak var authorButton: UIButton!
	@IBOutlet fileprivate weak var dateLabel: UILabel!
	@IBOutlet fileprivate weak var timeLabel: UILabel!
	@IBOutlet fileprivate weak var descriptionTextView: UITextView!
	
	// MARK: Properties
	var feedElement: HomeFeedElement!
	
	// MARK: Init
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	convenience init(feedElement: HomeFeedElement) {
		self.init(nibName: nil, bundle: nil)
		self.feedElement = feedElement
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        imageView.setImage(with: feedElement.mediaLink)
		titleLabel.text = feedElement.title
		flickrLinkButton.isEnabled = feedElement.flickrLink != ""
		dateTimeLabel.text = Date().offset(from: feedElement.date) + " ago"
		authorButton.setTitle(feedElement.author, for: .normal)
		
		let calendar = Calendar.current
		let day = calendar.component(.day, from: feedElement.date)
		let month = calendar.component(.month, from: feedElement.date)
		let year = calendar.component(.year, from: feedElement.date)%100
		dateLabel.text = "\(day)/\(month)/\(year)"
		
		let minute = calendar.component(.minute, from: feedElement.date)
		let hour = calendar.component(.hour, from: feedElement.date)
		timeLabel.text = "\(hour):\(minute/10)\(minute%10)"
		
		descriptionTextView.attributedText = self.feedElement.attributedDescriptionString
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

extension DetailsViewController {
	fileprivate func openLink(urlString: String) {
		guard let url = URL(string: urlString) else {
			let alert = UIAlertController(title: "Error!",
			                              message: "Sorry, Link is not working!",
                                          preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK",
			                              style: .cancel,
			                              handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
		let safariViewController = SFSafariViewController(url: url,
		                                                  entersReaderIfAvailable: false)
		navigationController?.present(safariViewController, animated: true)
	}
}

extension DetailsViewController {
	@IBAction func flickrLinkButtonPressed() {
		openLink(urlString: feedElement.flickrLink)
	}
	
	@IBAction func authorButtonPressed() {
		openLink(urlString: feedElement.authorLink)
	}
}
