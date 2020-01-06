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
	var flickrLink: URL?
	var mediaLink: URL?
	var dateTaken: String
	var imageDescription: String
	var publishedDate: String
	var author: String
	var authorId: String
	var tags: String
	
	// MARK: Calculated Properties
	var imagewidth: CGFloat = 180
	var imageHeight: CGFloat = 240
	var authorLink: URL?
	var date: Date = Date()
	var attributedDescriptionString: NSAttributedString = NSAttributedString()
	
	// MARK: Init
	init(response: [String: Any]) {
		title = response["title"] as? String ?? ""
        
        if let linkString = response["link"] as? String {
            flickrLink = URL(string: linkString)
        }
        if let linkString = (response["media"] as? [String: String])?["m"] {
            mediaLink = URL(string: linkString)
        }
        
		dateTaken = response["date_taken"] as? String ?? ""
		imageDescription = response["description"] as? String ?? ""
		publishedDate = response["published"] as? String ?? ""
		
		author = response["author"] as? String ?? ""
		var imageDescriptionElements = imageDescription.matchingStrings(regex: "<a href=\\\"(.*?)\">(.*?)</a>")
		if imageDescriptionElements.count > 0 {
            let linkString = imageDescriptionElements[0][1]
            authorLink = URL(string: linkString)
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

