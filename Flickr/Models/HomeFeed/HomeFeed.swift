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
        feedElements.removeAll()
        let params = ["format": "json#"]
        let regex = "(?s)\\{(.*)\\}"
        ApiManager.shared.getRequest(for: params, with: regex, self)
	}
	
    override func parse(_ response: [String: Any], for params: [String: Any]) {
        DispatchQueue.main.async {
            self.title = response["title"] as? String ?? ""
            self.link = response["link"] as? String ?? ""
            self.feedDescription = response["description"] as? String ?? ""
            
            var dateString = response["modified"] as? String ?? ""
            dateString = dateString.replacingOccurrences(of: "T", with: " ")
            self.modifiedDate = self.formatter.date(from: dateString) ?? Date()
            
            self.generator = response["generator"] as? String ?? ""
            
            let items = response["items"] as? [[String: Any]] ?? []
            for item in items {
                let feedElement = HomeFeedElement(response: item)
                self.feedElements.append(feedElement)
            }
        }
	}
	
	override func apiEndPoint() -> String {
		return "services/feeds/photos_public.gne"
	}
	
    override func didFetchSuccessfully(for params: [String: Any]) {
		delegate.didFetchSuccessfully(for: params)
	}
	
	override func didFail(with error: CustomError) {
		delegate.didFail(with: error)
	}
}
