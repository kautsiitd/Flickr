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
		
		var apiEndPoint = delegate.getApiEndPointWithParams(getParameters)
		apiEndPoint = self.appendGetParametersToURL(URL: apiEndPoint,
		                                            GetParams: getParameters)
		let apiFullPath = self.baseURL + apiEndPoint
		guard let url = URL(string: apiFullPath) else {
			delegate.didFailWithError(getParameters, nil)
			return
		}
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			
			guard let data = data else {
				guard let error = error else {
					delegate.didFailWithError(getParameters, nil)
					UIApplication.shared.isNetworkActivityIndicatorVisible = false
					return
				}
				delegate.didFailWithError(getParameters, error as NSError)
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				return
			}
			
			guard let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
				delegate.didFailWithError(getParameters, nil)
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				return
			}
			
			var trimStartIndex = 0
			var trimEndIndex =  "\(dataString)".count
			if prefix != "" {
				trimStartIndex = prefix.count
				trimEndIndex -= 1
			}
			
			let dataFormatted = "\(dataString)"[trimStartIndex..<trimEndIndex].data(using: String.Encoding.utf8,
			                                                               allowLossyConversion: false)!
			var json: Any
			do {
				json = try JSONSerialization.jsonObject(with: dataFormatted, options: JSONSerialization.ReadingOptions.allowFragments)
			} catch {
				delegate.didFailWithError(getParameters, nil)
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				return
			}
			guard let jsonConverted = json as? [String: Any] else {
				delegate.didFailWithError(getParameters, nil)
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				return
			}
			
			delegate.parseObject(jsonConverted,
			                     getParameters)
			if delegate.isValid() {
				delegate.didFetchSuccessfullyWithParams(getParameters)
			}
			else {
				delegate.didFailWithError(getParameters, nil)
			}
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
		}
		task.resume()
	}
}

extension ApiManager {
	fileprivate func appendGetParametersToURL(URL url: String,
	                                          GetParams getParams: [String: Any]?) -> String {
		var url = url
		if getParams == nil || getParams?.count == 0 {
			return url
		}
		var joinedGetParams: [String] = []
		for (key, value) in getParams! {
			joinedGetParams.append(key+"="+String(describing: value))
		}
		url += "?" + joinedGetParams.joined(separator: "&")
		return url
	}
}
