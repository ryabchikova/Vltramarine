//
//  PhotoRepositoryTests.swift
//  VltramarineTests
//
//  Created by Ryabchikova Elena on 05/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Vltramarine

class PhotoRepositoryTests: XCTestCase {

    var photoRepository: PhotoRepository?
    var databaseProvider: DatabaseProvider?
    
    let twoInputPhoto = [
        Photo(identifier: 1, url: URL(string: "http://www.vltramarine.ru/image1.jpg")!, publicationDate: Date(timeIntervalSince1970: 1000)),
        Photo(identifier: 2, url: URL(string: "http://www.vltramarine.ru/image2.jpg")!, publicationDate: Date(timeIntervalSince1970: 2000))
    ]
    
    override func setUp() {
        super.setUp()
        
        let configuration = getConfiguration(fromPlist: "TestConfiguration", in: Bundle(for: type(of: self)))
        let dbFileName = (configuration["database_file_name"]  as? String) ?? ""
        XCTAssertFalse(dbFileName.isEmpty)
        let docPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        self.databaseProvider = DatabaseProvider(dataBasePath: (docPaths[0] as NSString).appendingPathComponent(dbFileName) as String)
        self.photoRepository = PhotoRepositorySQLiteImpl(databaseProvider: databaseProvider!)
    }
    
    override func tearDown() {
        self.photoRepository = nil
        self.databaseProvider = nil
        super.tearDown()
    }
    
    func testRepositoryCreateWithSuccess() {
        XCTAssertNotNil(self.photoRepository)
    }
    
    func testClearRepository() {
        let expectation = self.expectation(description: "Clear repository")
        
        firstly {
            self.photoRepository!.deleteAllPhotos()
        }.done { success in
            XCTAssert(success)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
    
    func testSavePhotosInRepository() {
        let expectation = self.expectation(description: "Save array of photos to repository")
        
        firstly {
            self.photoRepository!.deleteAllPhotos()
        }.then { _ in
            self.photoRepository!.savePhotosFor(feedTheme: .art, photos: self.twoInputPhoto)
        }.done {
            expectation.fulfill()
        }.catch { error in
            XCTFail()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
    
    func testSaveEmptyArrayInRepository() {
        let expectation = self.expectation(description: "Save empty array of photos to repository")
        
        firstly {
            self.photoRepository!.savePhotosFor(feedTheme: .art, photos: [])
        }.done {
            expectation.fulfill()
        }.catch { error in
            XCTFail()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetSavedPhotosFromRepository() {
        let expectation = self.expectation(description: "Save photos, then get them from repository")
        
        firstly {
            self.photoRepository!.deleteAllPhotos()
        }.then { _ in
            self.photoRepository!.savePhotosFor(feedTheme: .art, photos: self.twoInputPhoto)
        }.then {
            self.photoRepository!.getPhotosFor(feedTheme: .art)
        }.done { outputPhotos in
            XCTAssert(outputPhotos.count == self.twoInputPhoto.count)
            XCTAssert(outputPhotos[0].identifier == 2)
            XCTAssert(outputPhotos[1].identifier == 1)
            expectation.fulfill()
        }.catch { error in
             XCTFail()
        }

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
    
    func testSetFavoriteState() {
        let expectation = self.expectation(description: "Save photos, then set favorite state for one")

        firstly {
            self.photoRepository!.deleteAllPhotos()
        }.then { _ in
           self.photoRepository!.savePhotosFor(feedTheme: .art, photos: self.twoInputPhoto)
        }.then {
            self.photoRepository!.setFavoriteStateForPhotoWith(identifier: 1, isFavorite: true)
        }.then { _ in
            self.photoRepository!.getPhotosFor(feedTheme: .art)
        }.done { outputPhotos in
            XCTAssert(outputPhotos.count == self.twoInputPhoto.count)
            XCTAssert(outputPhotos[0].identifier == 2)
            XCTAssert(outputPhotos[1].identifier == 1)
            XCTAssert(outputPhotos[0].isFavorite == false)
            XCTAssert(outputPhotos[1].isFavorite == true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
}
