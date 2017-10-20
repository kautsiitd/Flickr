//
//  FeedElement.swift
//  Roposo
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import SwiftyJSON

class FeedElement: FlickrObject {
	
	// Mark: Properties
	var title: String = ""
	var flickrLink: String = ""
	var mediaLink: String = ""
	var dateTaken: String = ""
	var imageDescription: String = ""
	var publishedDate: String = ""
	var author: String = ""
	var authorId: String = ""
	var tags: String = ""
	var imagewidth: CGFloat
	var imageHeight: CGFloat
	
	// MARK: Init
	init(responseObject: JSON) {
		title = responseObject["title"].string ?? ""
		flickrLink = responseObject["link"].string ?? ""
		mediaLink = responseObject["media"].dictionary?["m"]?.string ?? ""
		dateTaken = responseObject["date_taken"].string ?? ""
		imageDescription = responseObject["description"].string ?? ""
		publishedDate = responseObject["published"].string ?? ""
		author = responseObject["author"].string ?? ""
		authorId = responseObject["author_id"].string ?? ""
		tags = responseObject["tags"].string ?? ""
		
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
