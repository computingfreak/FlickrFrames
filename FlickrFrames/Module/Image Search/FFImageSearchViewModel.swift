//
//  FFImageSearchViewModel.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

protocol FFImageSearchViewModelProtocol {
    func loadImagesFor(searchText: String,
                       onCompletion completionHandler:((ServiceResponse<Bool>) -> ())?)
    func loadMoreImages(onCompletion completionHandler:((ServiceResponse<Bool>) -> ())?)
}

class FFImageSearchViewModel: NSObject {
    
    // MARK: Variables
    private(set) var imageURLs = [URL]()
    private var imageFetchService: FlickrImagesFetchServiceProtocol
    private var currentPageNumber = 1
    private var currentSearchText = ""
    private var sessionTask: URLSessionTask?
    
    // MARK: Initializer
    init(imageFetchService: FlickrImagesFetchServiceProtocol) {
        self.imageFetchService = imageFetchService
    }
    
    // MARK: Helper methods
    func cancelOngoingSessions() {
        sessionTask?.cancel()
    }
}

// MARK: FFImageSearchViewModelProtocol
extension FFImageSearchViewModel: FFImageSearchViewModelProtocol {
    
    func loadMoreImages(onCompletion completionHandler: ((ServiceResponse<Bool>) -> ())?) {
        // Cancel runnng service call
        sessionTask?.cancel()
        
        let newPageNumber = currentPageNumber + 1
        sessionTask =  imageFetchService.fetchImagesFromService(searchText: currentSearchText,
                                                                page: newPageNumber) { [unowned self] (response) in
                                                                    switch response {
                                                                    case .success(let imageURLs):
                                                                        self.currentPageNumber = newPageNumber
                                                                        self.imageURLs.append(contentsOf: imageURLs)
                                                                        completionHandler?(.success(true))
                                                                        
                                                                    case .failure(let reason):
                                                                        completionHandler?(.failure(reason))
                                                                    }
        }
    }
    
    func loadImagesFor(searchText: String,
                       onCompletion completionHandler:((ServiceResponse<Bool>) -> ())?) {
        // Cancel runnng service call
        sessionTask?.cancel()
        
        currentSearchText = searchText
        currentPageNumber = 1
        sessionTask =  imageFetchService.fetchImagesFromService(searchText: searchText,
                                                                page: currentPageNumber) { [unowned self] (response) in
                                                                    switch response {
                                                                        
                                                                    case .success(let imageURLs):
                                                                        self.imageURLs = imageURLs
                                                                        
                                                                        if self.imageURLs.isEmpty {
                                                                            completionHandler?(.failure(kUIStrings.NoImageFound.rawValue))
                                                                        } else {
                                                                            completionHandler?(.success(true))
                                                                        }
                                                                        
                                                                    case .failure(let reason):
                                                                        completionHandler?(.failure(reason))
                                                                    }
        }
    }
}

// MARK: UICollectionViewDataSource
extension FFImageSearchViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if imageURLs.isEmpty {
            return 0
        } else {
            return imageURLs.count + 1 // Loading indicator cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Return load more cell
        if indexPath.row == imageURLs.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFLoadmoreCollectionViewCell.cellIdentifier, for: indexPath) as! FFLoadmoreCollectionViewCell
            cell.activityIndicator.startAnimating()
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFImageCollectionViewCell.cellIdentifier,
                                                            for: indexPath) as? FFImageCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        
        // Return Image cell
        cell.configureCellWith(imageURL: imageURLs[indexPath.row])
        return cell
    }
}
