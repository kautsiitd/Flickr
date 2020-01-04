//
//  SearchElement.swift
//  Flickr
//
//  Created by Kautsya Kanu on 23/11/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

class SearchElement {
    
    // MARK: Properties
    var id: String = ""
    var owner: String = ""
    var secret: String = ""
    var server: String = ""
    var farm: Int = 1
    var title: String = ""
    var ispublic: Bool = false
    var isfriendly: Bool = false
    var isfamily: Bool = false
    
    // MARK: Calculated Properties
    var imageURL: String = ""
    
    // MARK: Init
    init(response: [String: Any]) {
        id = response["id"] as? String ?? ""
        owner = response["id"] as? String ?? ""
        secret = response["secret"] as? String ?? ""
        server = response["server"] as? String ?? ""
        farm = response["farm"] as? Int ?? 1
        title = response["title"] as? String ?? ""
        ispublic = response["isPublic"] as? Bool ?? false
        isfriendly = response["isfriendly"] as? Bool ?? false
        isfamily = response["isfamily"] as? Bool ?? false
        
        imageURL = "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

