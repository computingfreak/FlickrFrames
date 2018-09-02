//
//  FFImagesCollectionView.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

enum CollectionViewState {
    case loading
    case initial
    case loadingComplete
    case loadingFailed
    
    func text() -> String {
        switch self {
        case .loading:
            return kUIStrings.fetchingImages.rawValue
            
        case .initial:
            return kUIStrings.initialState.rawValue
            
        case .loadingComplete:
            return ""
            
        case .loadingFailed:
            return kUIStrings.fetchingFailed.rawValue
        }
    }
}

class FFImagesCollectionView: UIView {

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib.init(nibName: FFImageCollectionViewCell.cellIdentifier,
                                               bundle: nil),
                                    forCellWithReuseIdentifier: FFImageCollectionViewCell.cellIdentifier)
            collectionView.register(UINib.init(nibName: FFLoadmoreCollectionViewCell.cellIdentifier,
                                               bundle: nil),
                                    forCellWithReuseIdentifier: FFLoadmoreCollectionViewCell.cellIdentifier)
        }
    }
    @IBOutlet weak var stackViewActivityIndiactorContainer: UIStackView!
    @IBOutlet weak var lblLoadingText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Variables
    private var viewState: CollectionViewState = .initial {
        didSet {
            switchStateTo(newState: viewState)
        }
    }
    
    // MARK: View lifecycle
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        if self.subviews.count == 0 {
            let contentView = Bundle.main.loadNibNamed("FFImagesCollectionView",
                                                       owner: nil,
                                                       options: nil)?.first as! FFImagesCollectionView
            contentView.translatesAutoresizingMaskIntoConstraints = false
            return contentView
        }
        return self
    }
    
    // MARK: Helper mthods
    
    /// Switch current state of the views
    ///
    /// - Parameters:
    ///   - newState: Desired state
    ///   - shouldAnimate: Control if no animation is required
    func switchStateTo(newState: CollectionViewState,
                       withAnimation shouldAnimate: Bool = true) {
        lblLoadingText.text = newState.text()
        
        var animationDuration = kAnimationTimeDuration
        if !shouldAnimate {
            animationDuration = 0.0
        }
        
        UIView.animate(withDuration: animationDuration,
                       animations: { [unowned self] in
                        if newState == .loadingComplete {
                            self.stackViewActivityIndiactorContainer.alpha = 0
                            self.collectionView.alpha = 1
                            self.activityIndicator.stopAnimating()
                            
                        } else {
                            self.collectionView.alpha = 0
                            
                            if newState == .loading {
                                self.activityIndicator.startAnimating()
                            } else {
                                self.activityIndicator.stopAnimating()
                            }
                            self.stackViewActivityIndiactorContainer.alpha = 1
                        }
        })
    }    
}
