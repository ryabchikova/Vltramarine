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
    
    func testBadUrlProcess() {
        XCTAssertThrowsError(try self.xmlParser!.getAllPhotosFrom(feedUrl: "www.is a bad url.ru")) { error in
            let error = error as NSError
            XCTAssert(error.domain == kFeedXmlParserErrorDomain)
            XCTAssert(error.code == FeedXmlParserErrorCode.invalidDocumentUrl.rawValue)
        }
    }

    func testEmptyUrlProcess() {
        XCTAssertThrowsError(try self.xmlParser!.getAllPhotosFrom(feedUrl: "")) { error in
            let error = error as NSError
            XCTAssert(error.domain == kFeedXmlParserErrorDomain)
            XCTAssert(error.code == FeedXmlParserErrorCode.invalidDocumentUrl.rawValue)
        }
    }

    func testInvalidXmlDocumentParse() {
        let testFeedUrl = Bundle(for: type(of: self)).url(forResource: "invalidTestFeed", withExtension: "xml", subdirectory: nil)
        XCTAssertNotNil(testFeedUrl)
        
        var result = [Photo]()
        XCTAssertNoThrow(result = try self.xmlParser!.getAllPhotosFrom(feedUrl: testFeedUrl!.absoluteString))
        XCTAssert(result.isEmpty)
    }
    
    func testSimpleTextFileParse() {
        let testFeedUrl = Bundle(for: type(of: self)).url(forResource: "simpleTextFile", withExtension: "txt", subdirectory: nil)
        XCTAssertNotNil(testFeedUrl)
        
        var result = [Photo]()
        XCTAssertNoThrow(result = try self.xmlParser!.getAllPhotosFrom(feedUrl: testFeedUrl!.absoluteString))
        XCTAssert(result.isEmpty)
    }

    func testCorrectXmlDocumentParse() {
        let testFeedUrl = Bundle(for: type(of: self)).url(forResource: "correctTestFeed", withExtension: "xml", subdirectory: nil)
        XCTAssertNotNil(testFeedUrl)
        
        let result = try! self.xmlParser!.getAllPhotosFrom(feedUrl: testFeedUrl!.absoluteString)
        XCTAssertNotNil(result)
        XCTAssertTrue(result.count == 3)
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "dd MMM yyyy 'at' HH:mm"
        
        let photo1: Photo = result[0]
        XCTAssert(photo1.identifier == 27091)
        XCTAssert(photo1.url == URL(string: "http://www.vltramarine.ru//uploads/photos/27091/images_side_left.jpg?1506619351")!)
        XCTAssert(formatter.string(from: photo1.publicationDate) == "28 Sep 2017 at 20:22")
        XCTAssert(photo1.isFavorite == false)
        
        let photo2: Photo = result[1]
        XCTAssert(photo2.identifier == 27064)
        XCTAssert(photo2.url == URL(string: "http://www.vltramarine.ru//uploads/photos/27064/images_side_left.jpg?1506612744")!)
        XCTAssert(formatter.string(from: photo2.publicationDate) == "28 Sep 2017 at 18:32")
        XCTAssert(photo2.isFavorite == false)
        
        let photo3: Photo = result[2]
        XCTAssert(photo3.identifier == 27063)
        XCTAssert(photo3.url == URL(string: "http://www.vltramarine.ru//uploads/photos/27063/images_side_left.jpg?1506612685")!)
        XCTAssert(formatter.string(from: photo3.publicationDate) == "28 Sep 2017 at 18:31")
        XCTAssert(photo3.isFavorite == false)
    }
    
    func testParserPerformance() {
        self.measure {
            let testFeedUrl = Bundle(for: type(of: self)).url(forResource: "correctTestFeed", withExtension: "xml", subdirectory: nil)
            XCTAssertNotNil(testFeedUrl)
            try! self.xmlParser!.getAllPhotosFrom(feedUrl: testFeedUrl!.absoluteString)
        }
    }
}
