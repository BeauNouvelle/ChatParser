//
//  DictionaryExtensionsTests.swift
//  ChatParser
//
//  Created by Beau Young on 17/01/2016.
//  Copyright © 2016 Beau Nouvelle. All rights reserved.
//

import XCTest
@testable import ChatParser

class DictionaryExtensionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJSONStringFromDictionary() {
        let input = ["This":NSNumber(int: 4)]
        let expectedOutput = "{\n  \"This\" : 4\n}"
        XCTAssertEqual(input.prettyJSON, expectedOutput)
    }

    
}
