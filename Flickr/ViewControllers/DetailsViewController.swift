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
	@IBOutlet fileprivate weak var imageView: UIImageView!
	@IBOutlet fileprivate weak var titleLabel: UILabel!
	@IBOutlet fileprivate weak var flickrLinkButton: UIBarButtonItem!
	@IBOutlet fileprivate weak var dateTimeLabel: UILabel!
	@IBOutlet fileprivate weak var authorButton: UIButton!
	@IBOutlet fileprivate weak var dateLabel: UILabel!
	@IBOutlet fileprivate weak var timeLabel: UILabel!
	@IBOutlet fileprivate weak var descriptionLabel: UILabel!
	
	// MARK: Properties
	var feedElement: FeedElement!
	
	// MARK: Init
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	convenience init(feedElement: FeedElement) {
		self.init(nibName: nil, bundle: nil)
		self.feedElement = feedElement
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.imageView.setImageWithUrl(URL(string: feedElement.mediaLink))
		self.titleLabel.text = feedElement.title
		self.flickrLinkButton.isEnabled = feedElement.flickrLink != ""
		self.dateTimeLabel.text = Date().offset(from: feedElement.date) + " ago"
		self.authorButton.setTitle(feedElement.author, for: .normal)
		
		let calendar = Calendar.current
		let day = calendar.component(.day, from: feedElement.date)
		let month = calendar.component(.month, from: feedElement.date)
		let year = calendar.component(.year, from: feedElement.date)%100
		self.dateLabel.text = "\(day)/\(month)/\(year)"
		
		let minute = calendar.component(.minute, from: feedElement.date)
		let hour = calendar.component(.hour, from: feedElement.date)
		self.timeLabel.text = "\(hour):\(minute/10)\(minute%10)"
		
		self.descriptionLabel.attributedText = Parser.parseHTMLString(feedElement.imageDescription)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		switch segue.identifier ?? "" {
		case "presentingFullImageVC":
			let fullImageViewController = segue.destination as! FullImageViewController
			guard let url = URL(string: feedElement.mediaLink) else {
				break
			}
			fullImageViewController.imageLink = url
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
			                              preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "OK",
			                              style: .cancel,
			                              handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}
		let safariViewController = SFSafariViewController(url: url,
		                                                  entersReaderIfAvailable: false)
		navigationController?.present(safariViewController, animated: true)
	}
	
//	@IBAction func imageClicked() {
//		let fullImageViewController = FullImageViewController(feedElement: feedElement)
//		navigationController?.pushViewController(fullImageViewController,
//		                                         animated: true)
//	}
	
	@IBAction func flickrLinkButtonPressed() {
		openLink(urlString: feedElement.flickrLink)
	}
	
	@IBAction func authorButtonPressed() {
		openLink(urlString: feedElement.authorLink)
	}
}
