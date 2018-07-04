//
//  FeedXmlParserTests.swift
//  VltramarineUITests
//
//  Created by Ryabchikova Elena on 03/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import XCTest
@testable import Vltramarine

class FeedXmlParserTests: XCTestCase {
    
    var xmlParser: FeedXMLParser?
    
    override func setUp() {
        super.setUp()
        self.xmlParser = FeedXMLParser()
    }
    
    override func tearDown() {
        super.tearDown()
        self.xmlParser = nil
    }
    
    func testBadUrl() {
        let result = self.xmlParser!.getAllPhotosFrom(feedUrl: "www.100+.ru")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testEmptyUrl() {
        let result = self.xmlParser!.getAllPhotosFrom(feedUrl: "")
        XCTAssertTrue(result.isEmpty)
    }
    
    func testCorrectXml() {
        let result = self.xmlParser!.getAllPhotosFrom(feedUrl: Feed(feedTheme: .graffiti).url)
        XCTAssertTrue(result.count > 0)
    }
    
    func testParserPerformance() {
        self.measure {
            self.xmlParser!.getAllPhotosFrom(feedUrl: Feed(feedTheme: .graffiti).url)
        }
    }
    
}
