//
//  FeedElement.swift
//  Flickr
//
//  Created by Kautsya Kanu on 22/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation
import UIKit

class FeedElement: FlickrObject {
	
	// MARK: Properties
	var title: String = ""
	var flickrLink: String = ""
	var mediaLink: String = ""
	var dateTaken: String = ""
	var imageDescription: String = ""
	var publishedDate: String = ""
	var author: String = ""
	var authorId: String = ""
	var tags: String = ""
	
	// MARK: Calculated Properties
	var imagewidth: CGFloat = 180
	var imageHeight: CGFloat = 240
	var authorLink: String = ""
	var date: Date = Date()
	var attributedDescriptionString: NSAttributedString = NSAttributedString()
	
	// MARK: Init
	init(responseObject: [String: Any]) {
		super.init()
		title = responseObject["title"] as? String ?? ""
		flickrLink = responseObject["link"] as? String ?? ""
		mediaLink = (responseObject["media"] as? [String: String])?["m"] ?? ""
		dateTaken = responseObject["date_taken"] as? String ?? ""
		imageDescription = responseObject["description"] as? String ?? ""
		publishedDate = responseObject["published"] as? String ?? ""
		
		author = responseObject["author"] as? String ?? ""
		var imageDescriptionElements = imageDescription.matchingStrings(regex: "<a href=\\\"(.*?)\">(.*?)</a>")
		if imageDescriptionElements.count > 0 {
			authorLink = imageDescriptionElements[0][1]
			author = imageDescriptionElements[0][2]
		}
		
		authorId = responseObject["author_id"] as? String ?? ""
		tags = responseObject["tags"] as? String ?? ""
		
		imageDescriptionElements = imageDescription.matchingStrings(regex: "width=\\\"(.*?)\\\" height=\\\"(.*?)\\\"")
		let imageWidthString = imageDescriptionElements.first?[1] ?? "180"
		imagewidth = NumberFormatter().number(from: imageWidthString) as? CGFloat ?? 180
		let imageHeightString = imageDescriptionElements.first?[2] ?? "240"
		imageHeight = NumberFormatter().number(from: imageHeightString) as? CGFloat ?? 240
		
		DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
			imageDescriptionElements = self.imageDescription.matchingStrings(regex: "<p>(.*?)<\\/p>")
			self.attributedDescriptionString = Parser.parseHTMLString( imageDescriptionElements.count > 2 ? imageDescriptionElements[2][1] : "")
		}
	}
	
	override func isValid() -> Bool {
		return true
	}
}

