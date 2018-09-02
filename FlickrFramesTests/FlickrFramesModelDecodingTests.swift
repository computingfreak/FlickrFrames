//
//  FlickrFramesModelDecodingTests.swift
//  FlickrFramesTests
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import XCTest

class FlickrFramesModelDecodingTests: XCTestCase {
    
    // TEST USING MOCKED DATA
    /// Testing decoding of model(FFImageServiceResponseWrapper) when
    // received success from Images fetch service
    func testImagesFetchSuccessResponseModelDecodingFromMock() {
        guard let data = TestingUtils.imagesListJSON.data(using: .utf8),
            let parsedImageListWrapper = try? JSONDecoder().decode(FFImageServiceResponseWrapper.self,
                                                                   from: data)
            else {
                XCTFail("Parsing failed")
                return
        }
        
        XCTAssertEqual("ok", parsedImageListWrapper.statusMessage)
        XCTAssertNotNil(parsedImageListWrapper.imagesList)
        XCTAssertNil(parsedImageListWrapper.errorCode)
        XCTAssertNil(parsedImageListWrapper.errorMessage)
        XCTAssertNil(parsedImageListWrapper.errorMessage)
        
        if let imagesList = parsedImageListWrapper.imagesList {
            XCTAssertEqual(2, imagesList.pageNumber)
            XCTAssertEqual(2139, imagesList.numberOfPages)
            XCTAssertEqual(100, imagesList.imagesPerPage)
            XCTAssertEqual(5, imagesList.images.count)
        } else {
            XCTFail("Images list model decoding failed")
        }
        
        if let imageModel = parsedImageListWrapper.imagesList?.images.first {
            XCTAssertEqual("30521959238", imageModel.imageID)
            XCTAssertEqual("143290162@N03", imageModel.ownerID)
            XCTAssertEqual("86521be3fe", imageModel.secretID)
            XCTAssertEqual("1862", imageModel.serverNo)
            XCTAssertEqual(2, imageModel.farmNo)
            
            XCTAssertEqual("https://farm2.staticflickr.com/1862/30521959238_86521be3fe.jpg", imageModel.downloadURL?.absoluteString)
            XCTAssertNotNil(imageModel.downloadURL) // Testing if URL creation failed
            
        } else {
            XCTFail("Images model decoding failed")
        }
    }
    
    // TEST USING MOCKED DATA
    /// Testing decoding of model(FFImageServiceResponseWrapper) in case of
    // error from Images fetch service
    func testImagesFetchErrorResponseDecodingFromMock() {
        guard let data = TestingUtils.errorJSON.data(using: .utf8),
            let parsedImageListWrapper = try? JSONDecoder().decode(FFImageServiceResponseWrapper.self,
                                                                   from: data)
            else {
                XCTFail("Parsing failed")
                return
        }
        
        XCTAssertEqual("fail", parsedImageListWrapper.statusMessage)
        XCTAssertNil(parsedImageListWrapper.imagesList)
        XCTAssertEqual(100, parsedImageListWrapper.errorCode)
        XCTAssertEqual("Invalid API Key (Key has invalid format)", parsedImageListWrapper.errorMessage)
    }    
}
