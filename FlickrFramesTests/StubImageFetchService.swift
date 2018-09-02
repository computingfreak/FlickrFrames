//
//  StubImageFetchService.swift
//  FlickrFramesTests
//
//  Created by Vinayak Parmar on 02/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

class StubImageFetchService: FlickrImagesFetchServiceProtocol {        
    func fetchImagesFromService(searchText: String,
                                   page: Int,
                                   onCompletion completionHandler: @escaping ((ServiceResponse<[URL]>) -> ())) -> URLSessionTask? {
        switch page {
        case 1:
            let imgURLs: [URL] = [
                URL(string: "https://farm5.staticflickr.com/4295/35139557064_920180ba79.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4534/38399381002_554bf6768b.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4567/24559620908_71b0bcc6e0.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4550/38374724646_98b51e86da.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4541/26654387889_118666e098.jpg")!
            ]
            completionHandler(.success(imgURLs))
            
        case 2:
            let imgURLs: [URL] = [
                URL(string: "https://farm5.staticflickr.com/4318/35169237543_23fc22d8cb.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4314/35846768091_3b11c188c2.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4317/35808797002_8904d3bfd2.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4294/35979524635_c6641ba2d5.jpg")!
            ]
            completionHandler(.success(imgURLs))
            
        case 3:
            let imgURLs: [URL] = [
                URL(string: "https://farm5.staticflickr.com/4555/26654381219_9c9903aed6.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4553/26654374289_b37658b043.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4533/38374709666_f4b6783231.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4428/35696888123_bf289628b0.jpg")!,
                URL(string: "https://farm5.staticflickr.com/4437/35696567623_13e0760771.jpg")!
            ]
            completionHandler(.success(imgURLs))
            
        default:
            completionHandler(.failure("Something went wrong. Please try for different page number"))
        }
        return nil
    }
}
