//
//  GetFeed.swift
//  Flickr
//
//  Created by Kautsya Kanu on 22/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation

protocol GetFeedProtocol: class {
	func feedFetchedSuccessfully()
	func feedFetchingFailed(_ error: CustomError)
}

class GetFeed: FlickrObject {
	// Mark: Properties
	var title: String = ""
	var link: String = ""
	var feedDescription: String = ""
	private var modified: String = ""
	var generator: String = ""
	private var items: [Any] = []
	var delegate: GetFeedProtocol
	//	Formatted Properties
	var modifiedFeedDate: Date = Date()
	var feedElements: [FeedElement] = []
    
    init(delegate: GetFeedProtocol) {
        self.delegate = delegate
    }
	
	func fetchFeed() {
		ApiManager.sharedInstance.getRequest(GetParameters: ["format": "json#"],
		                                     JSONPrefix: "jsonFlickrFeed(",
		                                     Delegate: self)
	}
	
	override func parseObject(_ responseObject: [String: Any]) {
		title = responseObject["title"] as? String ?? ""
		link = responseObject["link"] as? String ?? ""
		feedDescription = responseObject["description"] as? String ?? ""
		modified = responseObject["modified"] as? String ?? ""
		generator = responseObject["generator"] as? String ?? ""
		items = responseObject["items"] as? [Any] ?? []
		
        feedElements = []
		for index in 0..<items.count {
			guard let item = items[index] as? [String: Any] else {
				continue
			}
			feedElements.append(FeedElement(responseObject: item))
		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
		modifiedFeedDate = dateFormatter.date(from: modified) ?? Date()
	}
	
	override func getApiEndPoint() -> String {
		return "feeds/photos_public.gne"
	}
	
	override func didFetchSuccessfully() {
		delegate.feedFetchedSuccessfully()
	}
	
	override func didFailWithError(_ error: CustomError) {
		delegate.feedFetchingFailed(error)
	}
}
