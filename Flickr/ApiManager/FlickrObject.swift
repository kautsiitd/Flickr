//
//  FlickrObject.swift
//  Roposo
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation

protocol FlickrObjectDelegate: class {
	/**
	get api end point from the class
	- parameter params: get parameters which were sent
	- returns: api end point
	*/
	func getApiEndPointWithParams(_ params: [String: Any]?) -> String
	
	/**
	called once the api response comes, asks the class to parse the json response
	- parameter responseObject: json response as Dictionary
	- parameter params:			get parameters which were sent
	*/
	func parseObject(_ responseObject: [String: Any], _ params: [String: Any]?)
	
	/**
	called once api call is succeeded and response is parsed
	- parameter params: get parameters which were sent
	*/
	func didFetchSuccessfullyWithParams(_ params: [String: Any]?)
	
	/**
	called if the api call gets failed
	- parameter params: get parameters which were sent
	- parameter error:	reason of the failure
	*/
	func didFailWithError(_ params: [String: Any]?, _ error: NSError?)
	
	/**
	validate object if it contains enough and correct info to use
	*/
	func isValid() -> Bool
}


class FlickrObject: NSObject, FlickrObjectDelegate {
	func getApiEndPointWithParams(_ params: [String: Any]?) -> String {
		return ""
	}
	func parseObject(_ responseObject: [String: Any], _ params: [String: Any]?) {}
	func didFetchSuccessfullyWithParams(_ params: [String: Any]?) {}
	func didFailWithError(_ params: [String: Any]?, _ error: NSError?) {}
	func isValid() -> Bool {
		return true
	}
}
