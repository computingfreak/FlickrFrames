//
//  FFImageModel.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

public struct FFImageModel: Codable {
    
    let imageID: String
    let ownerID: String
    let secretID: String
    let serverNo: String
    let farmNo: Int
    let title: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    var downloadURL: URL? {
        return URL(string: "https://farm\(farmNo).staticflickr.com/\(serverNo)/\(imageID)_\(secretID).jpg")
    }
    
    enum CodingKeys: String, CodingKey {
        case imageID = "id"
        case ownerID = "owner"
        case secretID = "secret"
        case serverNo = "server"
        case farmNo = "farm"
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
}

