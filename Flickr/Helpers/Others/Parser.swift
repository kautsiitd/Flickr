//
//  Parser.swift
//  Flickr
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit

class Parser {
	static func parseHTMLString(_ text: String?) -> NSAttributedString {
        guard let text = text else { return NSAttributedString(string: "") }
		
		let textEndsWith: String
		if text.hasSuffix("/p>") {
			textEndsWith = "p"
		} else if text.hasSuffix("/ol>") {
			textEndsWith = "ol"
		} else if text.hasSuffix("/ul>") {
			textEndsWith = "ul"
		} else {
			textEndsWith = ""
		}
		
        let format = "<style> " + textEndsWith + ":last-child{display: inline;} body{text-align: justify; font-family: 'Helvetica Neue'; font-size:12px; line-height:1.6;} ul,li,ol{position: relative; left: -10px;}</style>"
		let formattedText = format + text
		
		do {
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            if formattedText.data(using: .unicode) != nil {
                let data = formattedText.data(using: .unicode)!
				return try NSAttributedString(data: data, options: options, documentAttributes: nil)
			} else if formattedText.data(using: .unicode, allowLossyConversion: true) != nil {
                let data = formattedText.data(using: .unicode, allowLossyConversion: true)!
				return try NSAttributedString(data: data, options: options, documentAttributes: nil)
			}
		} catch let error as NSError {
			return NSAttributedString(string: error.localizedDescription)
		}
		return NSAttributedString(string: "")
	}
}
