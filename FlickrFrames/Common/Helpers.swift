//
//  Constants.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

// MARK: Constants
let kAnimationTimeDuration: TimeInterval =  0.35
let kCornerRadius: CGFloat = 3.0

// MARK: Enums
enum kUIStrings: String {
    case fetchingImages = "Fetching images!\nStay calm 😬"
    case initialState = "Nothing to show here for now.\nWhy not you try searching for something? 🤔"
    case fetchingFailed = "Something went wrong while fetching.\nPlease try again 🙁"
    case somethingWentWrong = "Something went wrong. Please try again later"
    case oops = "Oops!"
    case emptySearchtext = "Please enter some text and hit search 👇🏼"
    case NoImageFound = "No images found matching the text. Please try a different text."
}

// MARK: Extensions
extension UIView {
    var width: CGFloat {
        return bounds.size.width
    }
    var height: CGFloat {
        return bounds.size.height
    }
}

extension UIViewController {
    func showErrorAlert(withTitle title: String? = kUIStrings.oops.rawValue,
                        message: String? = kUIStrings.somethingWentWrong.rawValue) {
        DispatchQueue.main.async { [weak self] in
            if let weakSelf = self {
                let errorAlert = UIAlertController.init(title: title,
                                                        message: message,
                                                        preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction.init(title: "Ok",
                                                        style: .cancel, handler: nil))
                
                weakSelf.present(errorAlert,
                                 animated: true,
                                 completion: nil)
            }
        }
    }    
}

extension UICollectionView {
    func scrollToTop(withAnimation shouldAnimate: Bool = true) {
        setContentOffset(CGPoint.zero,
                         animated: shouldAnimate)
    }
}
