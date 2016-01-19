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
    
    // MARK: Succeed Tests
    func testExtractMentions() {
        let input = "@chris you around?"
        let expectedOutput = "{\n  \"mentions\" : [\n    \"chris\"\n  ]\n}"
        
        ChatParser().extractContent(.Mentions, fromString: input) { (actualOutput) -> () in
            XCTAssertEqual(actualOutput, expectedOutput)
        }
    }
    
    func testExtractEmoticons() {
        let input = "Good morning! (megusta) (coffee)"
        let expectedOutput = "{\n  \"emoticons\" : [\n    \"megusta\",\n    \"coffee\"\n  ]\n}"
        
        ChatParser().extractContent(.Emoticons, fromString: input) { (actualOutput) -> () in
            XCTAssertEqual(actualOutput, expectedOutput)
        }
    }
    
    // Best way to test web calls is to mock them out and use some dependency injection so that they are always reliable and will never change.
    // However, in order to keep these tests simple, I've opted to perform them over the network. 
    // These tests WILL fail should the web content ever change or become unreachable.
    func testExtractWebData() {
        let input = "Found this great website https://beaunouvelle.com"
        let expectedOutput = "{\n  \"links\" : [\n    {\n      \"title\" : \"Beau Nouvelle\",\n      \"url\" : \"https:\\/\\/beaunouvelle.com\"\n    }\n  ]\n}"
        
        let expectation = expectationWithDescription("Network Expectation")
        
        ChatParser().extractContent(.Links, fromString: input) { (actualOutput) -> () in
            XCTAssertEqual(actualOutput, expectedOutput)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testAllTypes() {
        let input = "@beaunouvelle, I love (megusta) what you posted on your blog https://beaunouvelle.com/projects/"
        let expectedOutput = "{\n  \"emoticons\" : [\n    \"megusta\"\n  ],\n  \"links\" : [\n    {\n      \"title\" : \"Beau Nouvelle - iOS Developer Portfolio\",\n      \"url\" : \"https:\\/\\/beaunouvelle.com\\/projects\\/\"\n    }\n  ],\n  \"mentions\" : [\n    \"beaunouvelle\"\n  ]\n}"
        
        let expectation = expectationWithDescription("Network Expectation")

        ChatParser().extractContent(.Any, fromString: input) { (actualOutput) -> () in
            XCTAssertEqual(actualOutput, expectedOutput)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    // MARK: Fail tests
    func testExtractNoMentions() {
        let input = "chris you around?"
        let expectedOutput = "{\n\n}"
        
        ChatParser().extractContent(.Mentions, fromString: input) { (actualOutput) -> () in
            XCTAssertEqual(actualOutput, expectedOutput)
        }
    }
    
    func testExtractNoEmoticons() {
        let input = "Good morning!"
        let expectedOutput = "{\n\n}"
        
        ChatParser().extractContent(.Emoticons, fromString: input) { (actualOutput) -> () in
            XCTAssertEqual(actualOutput, expectedOutput)
        }
    }
    
    func testExtractNoLink() {
        let input = "Found this great website"
        let expectedOutput = "{\n\n}"
        
        ChatParser().extractContent(.Links, fromString: input) { (actualOutput) -> () in
            XCTAssertEqual(actualOutput, expectedOutput)
        }
    }
    
    func testExtractPageTitleFromFakeURL() {
        let input = "Found this great website https://nosuchwebsiteexists.com"
        let expectedOutput = "{\n  \"links\" : [\n    {\n      \"url\" : \"https:\\/\\/nosuchwebsiteexists.com\"\n    }\n  ]\n}"
        
        let expectation = expectationWithDescription("Network Expectation")
        
        ChatParser().extractContent(.Links, fromString: input) { (actualOutput) -> () in
            XCTAssertEqual(actualOutput, expectedOutput)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testExtractPageTitleFromImageURL() {
        let input = "Check out this image https://assets-cdn.github.com/images/modules/jobs/logo.png"
        let expectedOutput = "{\n  \"links\" : [\n    {\n      \"url\" : \"https:\\/\\/assets-cdn.github.com\\/images\\/modules\\/jobs\\/logo.png\"\n    }\n  ]\n}"
        
        let expectation = expectationWithDescription("Network Expectation")

        ChatParser().extractContent(.Links, fromString: input) { (actualOutput) -> () in
            XCTAssertEqual(actualOutput, expectedOutput)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
