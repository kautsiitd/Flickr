//
//  SearchFeed.swift
//  Flickr
//
//  Created by Kautsya Kanu on 23/11/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import Foundation

protocol SearchFeedProtocol: class {
    func feedFetchedSuccessfully()
    func feedFetchingFailed(_ error: CustomError)
}

class SearchFeed: FlickrObject {
    // Mark: Properties
    private var delegate: SearchFeedProtocol!
    var searchText: String = "rose"
    var currentPage: Int = 1
    var totalPages: Int = 1
    var perPagePics: Int = 0
    var totalPics: Int = 0
    var page: Int = 1
    var searchElements: [SearchElement] = []
    
    init(delegate: SearchFeedProtocol) {
        self.delegate = delegate
    }
    
    func fetchFeed(searchText: String) {
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
    
    override func parseObject(_ responseObject: [String: Any]) {
        let response = responseObject["photos"] as? [String: Any] ?? [:]
        currentPage = response["page"] as? Int ?? 1
        totalPages = response["pages"] as? Int ?? 1
        perPagePics = response["perpage"] as? Int ?? 0
        totalPics = response["total"] as? Int ?? 0
        let items = response["photo"] as? [Any] ?? []
        
        searchElements = []
        for index in 0..<items.count {
            guard let item = items[index] as? [String: Any] else {
                continue
            }
            searchElements.append(SearchElement(responseObject: item))
        }
    }
    
    override func getApiEndPoint() -> String {
        return "rest"
    }
    
    override func didFetchSuccessfully() {
        delegate.feedFetchedSuccessfully()
    }
    
    override func didFailWithError(_ error: CustomError) {
        delegate.feedFetchingFailed(error)
    }
}
