//
//  ApiManager.swift
//  Flickr
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation
import UIKit

class ApiManager {
	
	// MARK: Variables
	static let shared = ApiManager()
	let session = URLSession.shared
    let baseURL = URL(string: "https://api.flickr.com")
    
    private init() {}
	
	/**
	sends get api call
	
     - parameter params: all the get parameters needs to be sent
     - parameter prefix: prefix before response like "jsonConverted("
     - parameter delegate: flickrObject delegate which implements didfetch, didfail etc.
	*/
    func getRequest(for params: [String: Any] = [:],
                    with regex: String = "(?s).*",
                    _ delegate: FlickrObjectDelegate) {
        let endPoint = delegate.apiEndPoint()
        guard let url = URL(string: endPoint, params: params, relativeTo: baseURL) else {
            delegate.didFail(with: .invalidURL)
            return
        }
		
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = self.fix(data, for: regex),
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let response = json as? [String: Any] else {
                delegate.didFail(with: .invalidData)
                return
            }
            
            delegate.parse(response)
            delegate.didFetchSuccessfully()
		}
		task.resume()
	}
    
    private func fix(_ data: Data?, for regex: String) -> Data? {
        guard let data = data,
            let dataString = String(data: data, encoding: .utf8),
            let newDataString = listMatches(for: regex, inString: dataString).first else {
            return nil
        }
        
        let newData = newDataString.data(using: .utf8)
        return newData
    }
    
    private func listMatches(for pattern: String,
                             inString string: String) -> [String] {
      guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
        return []
      }
      
      let range = NSRange(string.startIndex..., in: string)
      let matches = regex.matches(in: string, options: [], range: range)
      
      return matches.map {
        let range = Range($0.range, in: string)!
        return String(string[range])
      }
    }
}
