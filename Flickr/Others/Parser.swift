//
//  Parser.swift
//  Flickr
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit

class Parser {
	static func parseHTMLString(_ text: String?, fontSpec: UIFont? = UIFont(name: "Helvetica Neue", size: 12.0)) -> NSAttributedString {
		if text == nil || text == "" {
			return NSAttributedString(string: "")
		}
		
		let formattedText: String
		let textEndsWith: String
		
		if text!.hasSuffix("/p>") {
			textEndsWith = "p"
		} else if text!.hasSuffix("/ol>") {
			textEndsWith = "ol"
		} else if text!.hasSuffix("/ul>") {
			textEndsWith = "ul"
		} else {
			textEndsWith = ""
		}
		
		let format = "<style> " + textEndsWith + ":last-child{display: inline;} body{text-align: justify; font-family: '%@'; font-size:%fpx; line-height:%f;} ul,li,ol{position: relative; left: -10px;}</style>"
		let cssPart = NSString(format: format as NSString, fontSpec!.fontName, Float(fontSpec!.pointSize), 1.6) as String
		formattedText = cssPart + text!
		
		do {
			if formattedText.data(using: String.Encoding.unicode, allowLossyConversion: false) != nil {
				return try NSAttributedString( data: formattedText.data(using: String.Encoding.unicode, allowLossyConversion: false)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
			} else if formattedText.data(using: String.Encoding.unicode, allowLossyConversion: true) != nil {
				return try NSAttributedString( data: formattedText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
			}
		} catch let error as NSError {
			return NSAttributedString(string: error.localizedDescription)
		}
		return NSAttributedString(string: "")
	}
}
