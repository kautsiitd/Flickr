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
    private var currentQuery: String = "Rose"
    
    init(delegate: ApiProtocol) {
        self.delegate = delegate
    }
    
    private func fetch(for text: String, pageNumber: Int) {
        currentQuery = text
        let params = getParams(for: pageNumber)
        ApiManager.shared.getRequest(for: params, self)
    }
    
    private func getParams(for pageNumber: Int) -> [String: Any] {
        let urlQuery = currentQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return ["method": "flickr.photos.search",
                "api_key": "3e7cc266ae2b0e0d78e279ce8e361736",
                "format": "json",
                "nojsoncallback": 1,
                "safe_search": 1,
                "text": urlQuery ?? "Rose",
                "page": pageNumber]
    }
    
    override func parse(_ response: [String: Any], for params: [String: Any]) {
        if !isLatest(params) { return }
        DispatchQueue.main.async {
            let response = response["photos"] as? [String: Any] ?? [:]
            self.currentPage = response["page"] as? Int ?? 1
            self.totalPages = response["pages"] as? Int ?? 1
            self.perPagePics = response["perpage"] as? Int ?? 0
            self.totalPics = response["total"] as? Int ?? 0
            
            let photos = response["photo"] as? [[String: Any]] ?? []
            for photo in photos {
                let searchElement = SearchElement(response: photo)
                self.searchElements.append(searchElement)
            }
        }
    }
    
    private func isLatest(_ params: [String: Any]) -> Bool {
        let queryFetched = params["text"] as? String ?? ""
        let currentUrlQuery = currentQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return queryFetched == currentUrlQuery
    }
    
    override func apiEndPoint() -> String {
        return "services/rest"
    }
    
    override func didFetchSuccessfully(for params: [String: Any]) {
        if isLatest(params) {
            delegate.didFetchSuccessfully(for: params)
        }
    }
    
    override func didFail(with error: CustomError) {
        delegate.didFail(with: error)
    }
}

//MARK:- Available Functions
extension SearchFeed {
    func fetchFirstPage(for query: String) {
        searchElements.removeAll()
        currentPage = 1
        currentQuery = query
        fetch(for: currentQuery, pageNumber: currentPage)
    }
    func fetchCurrentPage() {
        fetch(for: currentQuery, pageNumber: currentPage)
    }
    func fetchNextPage() {
        currentPage += 1
        fetch(for: currentQuery, pageNumber: currentPage)
    }
}
