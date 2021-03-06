//
//  URL.swift
//  Flickr
//
//  Created by Kautsya Kanu on 04/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import Foundation

extension URL {
    init?(string: String, params: [String: Any], relativeTo url: URL?) {
        let paramsString = params.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        let urlString = string + "?" + paramsString
        self.init(string: urlString, relativeTo: url)
    }
    
    func isValid() -> Bool {
        return self.absoluteString != ""
    }
}
