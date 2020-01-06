//
//  CustomError.swift
//  Flickr
//
//  Created by Kautsya Kanu on 03/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import Foundation

enum CustomError {
    case invalidURL
    case invalidData
    case invalidLink
    case custom(error: NSError?)

    var title: String {
        switch self {
        case .invalidURL: return "InvalidURL"
        case .invalidData: return "InvalidData"
        case .invalidLink: return "InvalidLink"
        case let .custom(error): return error?.domain ?? "Oops!!"
        }
    }
    
    var description: String {
        switch self {
        case .invalidURL: return "Can't Open"
        case .invalidData: return "Can't Open"
        case .invalidLink: return "Sorry! Link is not working!! 😭"
        case let .custom(error):
            return error?.localizedDescription ?? "Something went wrong 😭"
        }
    }
}
