//
//  HomeFeed.swift
//  Flickr
//
//  Created by Kautsya Kanu on 22/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation

class HomeFeed: FlickrObject {
	// Mark: Properties
	var title: String = ""
	var link: String = ""
	var feedDescription: String = ""
    var modifiedDate: Date = Date()
	var generator: String = ""
	var feedElements: [HomeFeedElement] = []
    
    var delegate: ApiProtocol
    
    //MARK: Variables
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        return dateFormatter
    }()
    
    init(delegate: ApiProtocol) {
        self.delegate = delegate
    }
	
	func fetchFeed() {
        let params = ["format": "json#"]
        let regex = "(?s)\\{(.*)\\}"
        ApiManager.shared.getRequest(for: params, with: regex, self)
	}
	
	override func parse(_ response: [String: Any]) {
		title = response["title"] as? String ?? ""
		link = response["link"] as? String ?? ""
		feedDescription = response["description"] as? String ?? ""
		
        var dateString = response["modified"] as? String ?? ""
        dateString = dateString.replacingOccurrences(of: "T", with: " ")
        modifiedDate = formatter.date(from: dateString) ?? Date()
        
        generator = response["generator"] as? String ?? ""
        
        feedElements = []
        let items = response["items"] as? [[String: Any]] ?? []
        for item in items {
            let feedElement = HomeFeedElement(response: item)
            feedElements.append(feedElement)
        }
	}
	
	override func apiEndPoint() -> String {
		return "services/feeds/photos_public.gne"
	}
	
	override func didFetchSuccessfully() {
		delegate.didFetchSuccessfully()
	}
	
	override func didFail(with error: CustomError) {
		delegate.didFail(with: error)
	}
}
