//
//  FFImagesListModel.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

struct FFImagesListModel: Codable {
    
    let pageNumber: Int
    let numberOfPages: Int
    let imagesPerPage: Int
    let totalNumberOfImages: String
    let images: [FFImageModel]

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page"
        case numberOfPages = "pages"
        case imagesPerPage = "perpage"
        case totalNumberOfImages = "total"
        case images = "photo"
    }    
}
