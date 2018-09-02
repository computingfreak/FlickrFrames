//
//  FlickrNetworkServiceHelper.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

fileprivate let kFlickrAPIKey = "3e7cc266ae2b0e0d78e279ce8e361736"
fileprivate let kFlickrHOST = "api.flickr.com"

protocol FlickrImagesFetchServiceProtocol {
    func fetchImagesFromService(searchText: String,
                                   page: Int,
                                   onCompletion completionHandler:@escaping ((ServiceResponse<[URL]>) -> ())) -> URLSessionTask?
}

class FlickrNetworkServiceHelper: NSObject {
    
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = kFlickrHOST
        urlComponents.path = "/services/rest"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: kFlickrAPIKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "safe_search", value: "1"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        return urlComponents
    }
}

extension FlickrNetworkServiceHelper: FlickrImagesFetchServiceProtocol {
    
    @discardableResult func fetchImagesFromService(searchText: String,
                                                   page: Int,
                                                   onCompletion completionHandler:@escaping ((ServiceResponse<[URL]>) -> ())) -> URLSessionTask? {
        var components = imageFetchServiceComponents()
        components.queryItems?.append(contentsOf:[
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "text", value: searchText)]
        )
        
        guard let url = components.url  else {
            completionHandler(.failure(kUIStrings.somethingWentWrong.rawValue))
            return nil
        }
        
        let request = URLRequest(url: url)
        return NetworkHelpers.callAPIWith(request: request) { (parsedResponse: ServiceResponse<FFImageServiceResponseWrapper>) in
            
            switch parsedResponse {
            case .success(let parsedImagesWrapper):
                if parsedImagesWrapper.errorCode == nil,
                    let imagesList = parsedImagesWrapper.imagesList {
                    
                    let imagesURL = imagesList.images.compactMap({(imageModel) in
                        return imageModel.downloadURL
                    })
                    completionHandler(.success(imagesURL))
                    
                } else if let errorMessage = parsedImagesWrapper.errorMessage {
                    completionHandler(.failure(errorMessage))
                    
                } else {
                    completionHandler(.failure(kUIStrings.somethingWentWrong.rawValue))
                }
                
            case .failure(let reason):
                completionHandler(.failure(reason))
            }
        }
    }
    
    private func imageFetchServiceComponents() -> URLComponents {
        var components = urlComponents
        components.queryItems?.append(contentsOf: [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            ])
        return components
    }
}
