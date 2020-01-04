//
//  HomeFeedElement.swift
//  Flickr
//
//  Created by Kautsya Kanu on 22/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation
import UIKit

class HomeFeedElement {
	
	// MARK: Properties
	var title: String
	var flickrLink: String
	var mediaLink: String
	var dateTaken: String
	var imageDescription: String
	var publishedDate: String
	var author: String
	var authorId: String
	var tags: String
	
	// MARK: Calculated Properties
	var imagewidth: CGFloat = 180
	var imageHeight: CGFloat = 240
	var authorLink: String = ""
	var date: Date = Date()
	var attributedDescriptionString: NSAttributedString = NSAttributedString()
	
	// MARK: Init
	init(response: [String: Any]) {
		title = response["title"] as? String ?? ""
		flickrLink = response["link"] as? String ?? ""
		mediaLink = (response["media"] as? [String: String])?["m"] ?? ""
		dateTaken = response["date_taken"] as? String ?? ""
		imageDescription = response["description"] as? String ?? ""
		publishedDate = response["published"] as? String ?? ""
		
		author = response["author"] as? String ?? ""
		var imageDescriptionElements = imageDescription.matchingStrings(regex: "<a href=\\\"(.*?)\">(.*?)</a>")
		if imageDescriptionElements.count > 0 {
			authorLink = imageDescriptionElements[0][1]
			author = imageDescriptionElements[0][2]
		}
		
		authorId = response["author_id"] as? String ?? ""
		tags = response["tags"] as? String ?? ""
		
		imageDescriptionElements = imageDescription.matchingStrings(regex: "width=\\\"(.*?)\\\" height=\\\"(.*?)\\\"")
		let imageWidthString = imageDescriptionElements.first?[1] ?? "180"
		imagewidth = NumberFormatter().number(from: imageWidthString) as? CGFloat ?? 180
		let imageHeightString = imageDescriptionElements.first?[2] ?? "240"
		imageHeight = NumberFormatter().number(from: imageHeightString) as? CGFloat ?? 240
		
		DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
			imageDescriptionElements = self.imageDescription.matchingStrings(regex: "<p>(.*?)<\\/p>")
			self.attributedDescriptionString = Parser.parseHTMLString( imageDescriptionElements.count > 2 ? imageDescriptionElements[2][1] : "")
		}
	}
}

