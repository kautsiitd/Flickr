//
//  SearchElement.swift
//  Flickr
//
//  Created by Kautsya Kanu on 23/11/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

class SearchElement: FlickrObject {
    
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
    init(responseObject: [String: Any]) {
        super.init()
        id = responseObject["id"] as? String ?? ""
        owner = responseObject["id"] as? String ?? ""
        secret = responseObject["secret"] as? String ?? ""
        server = responseObject["server"] as? String ?? ""
        farm = responseObject["farm"] as? Int ?? 1
        title = responseObject["title"] as? String ?? ""
        ispublic = responseObject["isPublic"] as? Bool ?? false
        isfriendly = responseObject["isfriendly"] as? Bool ?? false
        isfamily = responseObject["isfamily"] as? Bool ?? false
        
        imageURL = "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

