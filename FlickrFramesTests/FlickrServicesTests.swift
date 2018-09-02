//
//  FlickrServiceTests.swift
//  FlickrFramesTests
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import XCTest

class FlickrServicesTests: XCTestCase {
    
    // TEST USING LIVE DATA
    /// Testing API response decoding and case if no images are received.
    
    func testImagesLoadFlowFromServer() {
        let expectation = self.expectation(description: "imageFetch")
        
        let imageFetchService = FlickrNetworkServices()
        imageFetchService.fetchImagesFromServiceFor(searchText: "buggati",
                                                    page: 1) { (response) in
                                                        switch response {
                                                        case .success(let urls):
                                                            XCTAssertGreaterThan(urls.count, 0, "No images received")
                                                            
                                                        case .failure(let reason):
                                                            XCTFail(reason)
                                                        }
                                                        
                                                        expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // TEST USING MOCKED DATA
    /// Testing search flow and load more flow
    
    func testSearchImageFlowFromMockedData() {
        let stubNetworkService = StubImageFetchService()
        let viewModel = FFImageSearchViewModel(imageFetchService: stubNetworkService)

        viewModel.loadImagesFor(searchText: "search test") { (response: ServiceResponse<Bool>) in
            switch response {
            case .success(let isSuccess):
                if isSuccess {
                    XCTAssertEqual(5,  viewModel.imageURLs.count)
                    
                    viewModel.loadMoreImages(onCompletion: { (response: ServiceResponse<Bool>) in
                        XCTAssertEqual(5 + 4,  viewModel.imageURLs.count)
                        
                        viewModel.loadMoreImages(onCompletion: { (response: ServiceResponse<Bool>) in
                            XCTAssertEqual(5 + 4 + 5,  viewModel.imageURLs.count)
                            
                            viewModel.loadMoreImages(onCompletion: { (response: ServiceResponse<Bool>) in
                                if case ServiceResponse.failure(let reason) = response {
                                    XCTAssertEqual("Something went wrong. Please try for different page number",
                                                   reason)
                                } else {
                                    XCTFail("Load more for an invalid didn't fail.")
                                }
                            })
                        })
                    })
                }
                
            case .failure(let reason):
                XCTFail(reason)
            }
        }
    }
    
    // TEST FROM LIVE DATA
    // Testing image download and caching
    func testImageDownloadAndCaching() {
        
    }
}
