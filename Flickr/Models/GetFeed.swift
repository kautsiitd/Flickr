//
//  GetFeed.swift
//  Roposo
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import SwiftyJSON

protocol GetFeedProtocol: class {
	func feedFetchedSuccessfully(_ feedElements: [FeedElement])
	func feedFetchingFailed(_ error: NSError?)
}

class GetFeed: FlickrObject {
	// Mark: Properties
	var title: String = ""
	var link: String = ""
	var feedDescription: String = ""
	private var modified: String = ""
	var generator: String = ""
	private var items: [JSON] = []
	weak var delegate: GetFeedProtocol?
	//	Formatted Properties
	var modifiedFeedDate: Date = Date()
	var feedElements: [FeedElement] = []
	
	func fetchFeed(_ delegate: GetFeedProtocol?) {
		self.delegate = delegate
		ApiManager.sharedInstance.getRequest(GetParameters: ["format": "json#"],
		                                     JSONPrefix: "jsonFlickrFeed(",
		                                     Delegate: self)
	}
	
	override func parseObject(_ responseObject: JSON, _ params: [String: Any]?) {
		title = responseObject["title"].string ?? ""
		link = responseObject["link"].string ?? ""
		feedDescription = responseObject["description"].string ?? ""
		modified = responseObject["modified"].string ?? ""
		generator = responseObject["generator"].string ?? ""
		items = responseObject["items"].array ?? []
		
		for item in items {
			feedElements.append(FeedElement(responseObject: item))
		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
		modifiedFeedDate = dateFormatter.date(from: modified) ?? Date()
	}
	
	override func isValid() -> Bool {
		return true
	}
	
	override func getApiEndPointWithParams(_ params: [String: Any]?) -> String {
		return "feeds/photos_public.gne"
	}
	
	override func didFetchSuccessfullyWithParams(_ params: [String: Any]?) {
		self.delegate?.feedFetchedSuccessfully(feedElements)
	}
	
	override func didFailWithError(_ params: [String: Any]?, _ error: NSError?) {
		self.delegate?.feedFetchingFailed(error)
	}
}
