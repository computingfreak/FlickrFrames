//
//  NetworkHelpers.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String:Any]

// Result of an operation, usually an asynchronous one.
public enum ServiceResponse<T> {
    case success(T)
    case failure(String)
}

class NetworkHelpers: NSObject {
    
    class func callAPIWith<T: Codable>(request: URLRequest,
                                       onCompletion completionHandler:@escaping ((ServiceResponse<T>) -> ()))  -> URLSessionTask? {
        
        let sessionTask =  URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                completionHandler(.failure(error.localizedDescription))
                
            } else if let receivedData = data,
                let parsedResponse = try? JSONDecoder().decode(T.self,
                                                               from: receivedData)  {
                completionHandler(.success(parsedResponse))
            } else {
                completionHandler(.failure("Something went wrong. Please try again later"))
            }
        }
        sessionTask.resume()
        return sessionTask
    }
}
