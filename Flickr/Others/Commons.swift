//
//  Commons.swift
//  Roposo
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation
import UIKit

class Commons {
	static func getPhoneWidth() -> CGFloat {
		return UIScreen.main.bounds.size.width
	}
	
	static func getPhoneHeight() -> CGFloat {
		return UIScreen.main.bounds.size.height
	}
	
	static func getDPR() -> CGFloat {
		return CGFloat(CGFloat(UIScreen.main.nativeBounds.width / UIScreen.main.fixedCoordinateSpace.bounds.width))
	}
}

// MARK: For Imgix
extension Commons {
	static func formatURLforImgix(_ url: String, viewWidth: CGFloat, viewHeight: CGFloat, contentMode: UIViewContentMode) -> String {
		// split url into base url and params
		// split params into dictionary
		// add/override imgix params to params dictionary
		// form imgix url
		var baseURL  = ""
		var paramURL = ""
		var paramDict = [String: String]()
		
		if url.contains("?") {
			let urlArr = url.characters.split {$0 == "?"}.map(String.init)
			baseURL = urlArr[0]
			
			if urlArr.count > 1 {
				paramURL = urlArr[1]
			}
		} else {
			baseURL = url
		}
		
		if paramURL.contains("=") {
			let paramArr = paramURL.characters.split {$0 == "&"}.map(String.init)
			for params in paramArr {
				if params.contains("=") {
					let keyVal = params.characters.split {$0 == "="}.map(String.init)
					if keyVal.count >= 2 {
						let key = keyVal[0]
						let value = keyVal[1]
						paramDict[key] = value
					}
				}
			}
		}
		
		if viewHeight > 0 {
			paramDict["h"] = String(describing: viewHeight)
		}
		if viewWidth > 0 {
			paramDict["w"] = String(describing: viewWidth)
		} else {
			paramDict["w"] = String(describing: Commons.getPhoneWidth())
		}
		
		paramDict["dpr"] = String(describing: min(Commons.getDPR(), 2))
		
		//changes for webp support
		paramDict["fit"] = "min"
		paramDict["fm"] = "webp"
		paramDict["auto"] = "compress"
		
		paramURL = ""
		
		for (key, val) in paramDict {
			paramURL += key + "=" + val + "&"
		}
		paramURL = paramURL.trimmingCharacters(in: CharacterSet(charactersIn: "&"))
		
		return baseURL + (paramURL == "" ? "" : ("?" + paramURL))
	}
}
