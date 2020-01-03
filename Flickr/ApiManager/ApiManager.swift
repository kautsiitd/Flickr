//
//  ApiManager.swift
//  Flickr
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation
import UIKit

class ApiManager: NSObject {
	
	// MARK: Variables
	static let sharedInstance = ApiManager()
	let session = URLSession.shared
	let baseURL = "https://api.flickr.com/services/"
	
	/**
	sends get api call
	
	- parameter getParameters: all the get parameters needs to be sent
	- parameter delegate:	  flickrObject delegate which implements didfetch, didfail etc.
	*/
	func getRequest(GetParameters getParameters: [String: Any]?,
	                JSONPrefix prefix: String,
	                Delegate delegate: FlickrObjectDelegate) {
		
		let apiEndPoint = appendGetParametersTo(URL: delegate.getApiEndPoint(),
		                                            GetParams: getParameters)
		let apiFullPath = baseURL + apiEndPoint
		guard let url = URL(string: apiFullPath) else {
            delegate.didFailWithError(.invalidURL)
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			
			guard let data = data,
                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                delegate.didFailWithError(.invalidData)
				return
			}
			
			var trimStartIndex = 0
			var trimEndIndex =  "\(dataString)".count
			if prefix != "" {
				trimStartIndex = prefix.count
				trimEndIndex -= 1
			}
			guard let dataFormatted = "\(dataString)"[trimStartIndex..<trimEndIndex]
                .data(using: String.Encoding.utf8,
                      allowLossyConversion: false) else {
                        delegate.didFailWithError(.invalidData)
                        return
            }
            
			var json: Any
			do {
				json = try JSONSerialization.jsonObject(with: dataFormatted, options: JSONSerialization.ReadingOptions.allowFragments)
			} catch {
                delegate.didFailWithError(.invalidData)
				return
			}
			guard let jsonConverted = json as? [String: Any] else {
                delegate.didFailWithError(.invalidData)
				return
			}
			
			delegate.parseObject(jsonConverted)
            delegate.didFetchSuccessfully()
		}
		task.resume()
	}
}

extension ApiManager {
	private func appendGetParametersTo(URL url: String,
                                       GetParams getParams: [String: Any]?) -> String {
		if getParams == nil || getParams?.count == 0 {
			return url
		}
		var joinedGetParams: [String] = []
		for (key, value) in getParams! {
			joinedGetParams.append(key+"="+String(describing: value))
		}
        var url = url
		url += "?" + joinedGetParams.joined(separator: "&")
		return url
	}
}
