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
    case retryRemote
    case custom(_ error: Error)

    var title: String {
        switch self {
        case .invalidURL:
            return "InvalidURL"
        case .invalidData:
            return "InvalidData"
        case .retryRemote:
            return "Retry"
        case .custom(_):
            return "Oops!!"
        }
    }
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Can't Open"
        case .invalidData:
            return "Can't Open"
        case .retryRemote:
            return "Try Again!!"
        case let .custom(error):
            return error.localizedDescription
        }
    }
}
