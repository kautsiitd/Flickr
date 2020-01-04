//
//  SearchFeed.swift
//  Flickr
//
//  Created by Kautsya Kanu on 23/11/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import Foundation

class SearchFeed: FlickrObject {
    // Mark: Properties
    var currentPage: Int = 1
    var totalPages: Int = 1
    var perPagePics: Int = 0
    var totalPics: Int = 0
    var page: Int = 1
    var searchElements: [SearchElement] = []
    
    private var delegate: ApiProtocol
    
    init(delegate: ApiProtocol) {
        self.delegate = delegate
    }
    
    func fetch(for text: String, pageNumber: Int) {
        let params = getParams(for: text, pageNumber: pageNumber)
        ApiManager.shared.getRequest(for: params, self)
    }
    
    private func getParams(for text: String, pageNumber: Int) -> [String: Any] {
        return ["method": "flickr.photos.search",
                "api_key": "3e7cc266ae2b0e0d78e279ce8e361736",
                "format": "json",
                "nojsoncallback": 1,
                "safe_search": 1,
                "text": text,
                "page": pageNumber]
    }
    
    override func parse(_ response: [String: Any]) {
        let response = response["photos"] as? [String: Any] ?? [:]
        currentPage = response["page"] as? Int ?? 1
        totalPages = response["pages"] as? Int ?? 1
        perPagePics = response["perpage"] as? Int ?? 0
        totalPics = response["total"] as? Int ?? 0
        
        let photos = response["photo"] as? [[String: Any]] ?? []
        searchElements = []
        for photo in photos {
            let searchElement = SearchElement(response: photo)
            searchElements.append(searchElement)
        }
    }
    
    override func apiEndPoint() -> String {
        return "services/rest"
    }
    
    override func didFetchSuccessfully() {
        delegate.didFetchSuccessfully()
    }
    
    override func didFail(with error: CustomError) {
        delegate.didFail(with: error)
    }
}
