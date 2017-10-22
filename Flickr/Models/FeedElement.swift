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
	var imagewidth: CGFloat
	var imageHeight: CGFloat
	var authorLink: String = ""
	var date: Date = Date()
	
	// MARK: Init
	init(responseObject: [String: Any]) {
		title = responseObject["title"] as? String ?? ""
		flickrLink = responseObject["link"] as? String ?? ""
		mediaLink = (responseObject["media"] as? [String: String])?["m"] ?? ""
		dateTaken = responseObject["date_taken"] as? String ?? ""
		imageDescription = responseObject["description"] as? String ?? ""
		publishedDate = responseObject["published"] as? String ?? ""
		author = responseObject["author"] as? String ?? ""
		authorId = responseObject["author_id"] as? String ?? ""
		tags = responseObject["tags"] as? String ?? ""
		
		let imageWidthString = imageDescription.matchingStrings(regex: "width=\\\"(.*?)\\\"").first?[0] ?? "180"
		imagewidth = NumberFormatter().number(from: imageWidthString) as? CGFloat ?? 180
		let imageHeightString = imageDescription.matchingStrings(regex: "width=\\\"(.*?)\\\"").first?[0] ?? "240"
		imageHeight = NumberFormatter().number(from: imageHeightString) as? CGFloat ?? 240
		super.init()
	}
	
	override func isValid() -> Bool {
		return true
	}
}

