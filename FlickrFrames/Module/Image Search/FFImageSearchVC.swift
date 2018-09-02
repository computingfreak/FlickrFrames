//
//  FFImageSearchVC.swift
//  FlickrFrames
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

class FFImageSearchVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var customCollectionView: FFImagesCollectionView!
    
    // MARK: Variables
    var viewModel: FFImageSearchViewModel!
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let flickrNetworkServices = FlickrNetworkServices()
        viewModel = FFImageSearchViewModel(imageFetchService: flickrNetworkServices)
        
        customCollectionView.collectionView.dataSource = viewModel
        customCollectionView.collectionView.delegate = self
        customCollectionView.switchStateTo(newState: .initial)
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self,
                                                              action: #selector(didTapView)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Since this screen loads alot of images, it will contribute to more memory
        // Reseting cache to remove all the cached images to avoid app quit by OS
        ImageCacheHelper.resetCache()
    }
    
    // MARK: Button Tap/Touch listeners
    @objc func didTapView() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

// MARK: UISearchBarDelegate
extension FFImageSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            showErrorAlert(withTitle: kUIStrings.oops.rawValue,
                               message: kUIStrings.emptySearchtext.rawValue)
            return
        }

        // Close keyboard
        searchBar.resignFirstResponder()
        
        // Switch to loading state
        customCollectionView.switchStateTo(newState: .loading)
        customCollectionView.collectionView.scrollToTop()
        
        viewModel.loadImagesFor(searchText: searchText) {[weak self] (response) in
            DispatchQueue.main.async { [weak self] in
                if let weakSelf = self {
                    switch response {
                    case .success(let isSuccess):
                        if isSuccess {
                            weakSelf.customCollectionView.collectionView.reloadData()
                        }
                        weakSelf.customCollectionView.switchStateTo(newState: .loadingComplete)
                        
                    case .failure(let reason):
                        weakSelf.customCollectionView.switchStateTo(newState: .loadingFailed)
                        weakSelf.showErrorAlert(message: reason)
                    }
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.cancelOngoingSessions()
    }
}

// MARK: UICollectionViewDelegate
extension FFImageSearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        // Start fetching new data if last cell is going to be displayed
        if indexPath.row == viewModel.imageURLs.count {
            viewModel.loadMoreImages() { (response) in
                if case .success(let isSuccess) = response, isSuccess {
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension FFImageSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let columnSpacing = flowLayout.minimumLineSpacing
        let horizontalInset = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        
        let cellWidth = (collectionView.width - horizontalInset - columnSpacing * 2) / 3
        
        return CGSize(width: cellWidth,
                      height: cellWidth) // Height and width same for square images
    }
}

