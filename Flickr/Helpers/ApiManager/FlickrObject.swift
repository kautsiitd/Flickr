//
//  FlickrObject.swift
//  Flickr
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation

protocol ApiProtocol {
    func didFetchSuccessfully(for params: [String: Any])
    func didFail(with error: CustomError)
}

protocol FlickrObjectDelegate: ApiProtocol {
	func apiEndPoint() -> String
    func parse(_ response: [String: Any], for params: [String: Any])
}


class FlickrObject: NSObject, FlickrObjectDelegate {
	func apiEndPoint() -> String { return "" }
    func parse(_ response: [String : Any], for params: [String: Any]) {}
    func didFetchSuccessfully(for params: [String: Any]) {}
	func didFail(with error: CustomError) {}
}
