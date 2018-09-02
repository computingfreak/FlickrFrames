//
//  FFImageServiceResponseWrapper.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

struct FFImageServiceResponseWrapper: Codable {
    
    let imagesList: FFImagesListModel?
    let statusMessage: String
    let errorCode: Int?
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case imagesList = "photos"
        case statusMessage = "stat"
        case errorCode = "code"
        case errorMessage = "message"
    }
}
