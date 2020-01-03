//
//  FlickrObject.swift
//  Flickr
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation

protocol FlickrObjectDelegate: class {
	/**
	get api end point from the class
	- returns: api end point
	*/
	func getApiEndPoint() -> String
	
	/**
	called once the api response comes, asks the class to parse the json response
	- parameter responseObject: json response as Dictionary
	*/
	func parseObject(_ responseObject: [String: Any])
	
	/**
	called once api call is succeeded and response is parsed
	*/
	func didFetchSuccessfully()
	
	/**
	called if the api call gets failed
	- parameter error:	reason of the failure
	*/
	func didFailWithError(_ error: CustomError)
}


class FlickrObject: NSObject, FlickrObjectDelegate {
	func getApiEndPoint() -> String {
		return ""
	}
	func parseObject(_ responseObject: [String: Any]) {}
	func didFetchSuccessfully() {}
	func didFailWithError(_ error: CustomError) {}
}
