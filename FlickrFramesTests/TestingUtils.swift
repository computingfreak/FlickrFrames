//
//  Utils.swift
//  FlickrFramesTests
//
//  Created by Vinayak Parmar on 01/09/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import Foundation

class TestingUtils: NSObject {
    
    static var imagesListJSON: String {
        return """
        {
        "photos": {
        "page": 2,
        "pages": 2139,
        "perpage": 100,
        "total": "213830",
        "photo": [
        {
        "id": "30521959238",
        "owner": "143290162@N03",
        "secret": "86521be3fe",
        "server": "1862",
        "farm": 2,
        "title": "Fall 2018’s Biggest Shoe Trends Are Coming in Hot, Ready or Not",
        "ispublic": 1,
        "isfriend": 0,
        "isfamily": 0
        },
        {
        "id": "42580686270",
        "owner": "78636599@N00",
        "secret": "b4b4374b1a",
        "server": "1870",
        "farm": 2,
        "title": "PPG92505",
        "ispublic": 1,
        "isfriend": 0,
        "isfamily": 0
        },
        {
        "id": "43672593044",
        "owner": "14036428@N00",
        "secret": "12ddbfcb68",
        "server": "1849",
        "farm": 2,
        "title": "Lorenzo hides from the air show.",
        "ispublic": 1,
        "isfriend": 0,
        "isfamily": 0
        },
        {
        "id": "42580656890",
        "owner": "139152351@N08",
        "secret": "8ccaa39c76",
        "server": "1860",
        "farm": 2,
        "title": "Pros And Cons Of Giving Coconut Oil To Your Cat: Safe Or Bad?- Cat Care Tips",
        "ispublic": 1,
        "isfriend": 0,
        "isfamily": 0
        },
        {
        "id": "29451847487",
        "owner": "66972807@N00",
        "secret": "72528399f2",
        "server": "1859",
        "farm": 2,
        "title": "Waiting & Watching",
        "ispublic": 1,
        "isfriend": 0,
        "isfamily": 0
        },]
        },
        "stat": "ok"
        }
        """
    }
    
    static var errorJSON: String {
        return """
        {
        "stat": "fail",
        "code": 100,
        "message": "Invalid API Key (Key has invalid format)"
        }
        """
    }    
}
