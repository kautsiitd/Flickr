//
//  SearchFeed.swift
//  Flickr
//
//  Created by Kautsya Kanu on 23/11/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import Foundation

protocol SearchFeedProtocol: class {
    func feedFetchedSuccessfully(_ feed: SearchFeed)
    func feedFetchingFailed(_ error: NSError?)
}

class SearchFeed: FlickrObject {
    // Mark: Properties
    weak var delegate: SearchFeedProtocol?
    var searchText: String = "rose"
    var currentPage: Int = 1
    var totalPages: Int = 1
    var perPagePics: Int = 0
    var totalPics: Int = 0
    var page: Int = 1
    var searchElements: [SearchElement] = []
    
    func fetchFeed(_ delegate: SearchFeedProtocol?, searchText: String) {
        self.delegate = delegate
        self.searchText = searchText
        ApiManager.sharedInstance.getRequest(GetParameters: getParams(),
                                             JSONPrefix: "",
                                             Delegate: self)
    }
    
    private func getParams() -> [String: Any]? {
        return ["method": "flickr.photos.search",
                "api_key": "3e7cc266ae2b0e0d78e279ce8e361736",
                "format": "json",
                "nojsoncallback": 1,
                "safe_search": 1,
                "text": searchText,
                "page": currentPage]
    }
    
    override func parseObject(_ responseObject: [String: Any], _ params: [String: Any]?) {
        let response = responseObject["photos"] as? [String: Any] ?? [:]
        currentPage = response["page"] as? Int ?? 1
        totalPages = response["pages"] as? Int ?? 1
        perPagePics = response["perpage"] as? Int ?? 0
        totalPics = response["total"] as? Int ?? 0
        let items = response["photo"] as? [Any] ?? []
        
        for index in 0..<items.count {
            guard let item = items[index] as? [String: Any] else {
                continue
            }
            searchElements.append(SearchElement(responseObject: item))
        }
    }
    
    override func getApiEndPointWithParams(_ params: [String: Any]?) -> String {
        return "rest"
    }
    
    override func didFetchSuccessfullyWithParams(_ params: [String: Any]?) {
        self.delegate?.feedFetchedSuccessfully(self)
    }
    
    override func didFailWithError(_ params: [String: Any]?, _ error: NSError?) {
        self.delegate?.feedFetchingFailed(error)
    }
}
