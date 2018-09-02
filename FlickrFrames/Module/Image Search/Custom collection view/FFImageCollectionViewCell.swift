//
//  FFImageCollectionViewCell.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

class FFImageCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = kCornerRadius
        }
    }

    // MARK: Variables
    static let cellIdentifier = "FFImageCollectionViewCell"
    private var imageDownloadTask: URLSessionTask?
    
    // MARK: View lifecycle
    override func prepareForReuse() {
        imageView.image = nil
        
        super.prepareForReuse()
    }
    
    // MARK: Helper methods
    func configureCellWith(imageURL: URL) {
        
        /// To avoid random image flickering bug when collectionview is scrolled
        // Since cells are reused, some previous session task of image download might complete late and
        // affect the existing visible cells which results into random image flickering effect.
        imageDownloadTask?.cancel()
        
        imageDownloadTask = imageView.loadImageUsingCacheWith(imgURL: imageURL)
    }

}
