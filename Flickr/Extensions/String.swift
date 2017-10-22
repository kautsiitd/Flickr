//
//  String.swift
//  Flickr
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation

extension String {
	subscript(_ range: CountableRange<Int>) -> String {
		let idx1 = index(startIndex, offsetBy: range.lowerBound)
		let idx2 = index(startIndex, offsetBy: range.upperBound)
		return self[idx1..<idx2]
	}
	
	var count: Int {
		return characters.count
	}
	
	func matchingStrings(regex: String) -> [[String]] {
		guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
		let nsString = self as NSString
		let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
		return results.map { result in
			(0..<result.numberOfRanges).map { result.rangeAt($0).location != NSNotFound
				? nsString.substring(with: result.rangeAt($0))
				: ""
			}
		}
	}
}
