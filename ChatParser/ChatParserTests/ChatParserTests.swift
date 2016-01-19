//
//  ChatParserTests.swift
//  ChatParserTests
//
//  Created by Beau Nouvelle on 16/01/2016.
//  Copyright © 2016 Beau Nouvelle. All rights reserved.
//

import XCTest
@testable import ChatParser

class ChatParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Tests
    func testMentions() {
        let input = "@chris you around?"
        let expectedOutput = "{\n  \"mentions\" : [\n    \"chris\"\n  ]\n}"
        
        let actualOutput = ChatParser().extractContent(.Mentions, fromString: input)
        XCTAssertEqual(actualOutput, expectedOutput)
    }
    
    func testEmoticons() {
        let input = "Good morning! (megusta) (coffee)"
        let expectedOutput = "{\n  \"emoticons\" : [\n    \"megusta\",\n    \"coffee\"\n  ]\n}"
        
        let actualOutput = ChatParser().extractContent(.Emoticons, fromString: input)
        XCTAssertEqual(actualOutput, expectedOutput)
    }
    
    func testLinks() {
        let input = "Found this great website http://beaunouvelle.com"
        let expectedOutput = "{\n  \"links\" : [\n    {\n      \"title\" : \"Beau Nouvelle\",\n      \"url\" : \"http:\\/\\/beaunouvelle.com\"\n    }\n  ]\n}"
        
        let actualOutput = ChatParser().extractContent(.Links, fromString: input)
        XCTAssertEqual(actualOutput, expectedOutput)
    }
    
    func testAll() {
        let input = "@beaunouvelle, I love (megusta) what you posted on your blog https://beaunouvelle.com/projects/"
        let expectedOutput = "{\n  \"emoticons\" : [\n    \"megusta\"\n  ],\n  \"links\" : [\n    {\n      \"title\" : \"Beau Nouvelle - iOS Developer Portfolio\",\n      \"url\" : \"https:\\/\\/beaunouvelle.com\\/projects\\/\"\n    }\n  ],\n  \"mentions\" : [\n    \"beaunouvelle\"\n  ]\n}"
        
        let actualOutput = ChatParser().extractContent(.Any, fromString: input)
        XCTAssertEqual(actualOutput, expectedOutput)
    }
    
}
