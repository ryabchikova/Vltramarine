//
//  PhotoRepositorySQLiteImpl.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 01/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import PromiseKit
import FMDB

class PhotoRepositorySQLiteImpl: PhotoRepository {
    
    private var queue: FMDatabaseQueue!
    
    init() {
        self.queue = FMDatabaseQueue(path: self.dbPath())
        self.queue.inDatabase { db in
            let query = """
                CREATE TABLE IF NOT EXISTS Photo (
                    url TEXT PRIMARY KEY,
                    feedTheme INTEGER,
                    pubDate TEXT,
                    isFavorite INTEGER DEFAULT 0);
            """
            if !db.executeUpdate(query, withArgumentsIn: []) {
                fatalError("Setup database Vltramarine.sqlite failed. Error: \(db.lastErrorMessage())")
            }
        }
    }
    
    private func dbPath() -> String {
        let docPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return (docPaths[0] as NSString).appendingPathComponent("Vltramarine.sqlite") as String
    }
    
    // MARK: Data processing
    
    func savePhotosFor(feedTheme: FeedTheme, photos: [Photo]) -> Promise<Bool> {
        return Promise { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                var transactionFailed = false
                self.queue.inTransaction { db, rollback in
                    for item in photos {
                        let paramsDictionary: [AnyHashable: Any] = [
                            //"identifier": self.hashOf(value: item.url.absoluteString),
                            "url": item.url.absoluteString,
                            "feedTheme": feedTheme.rawValue,
                            "pubDate": item.publicationDate
                        ]
                        
                        let success = db.executeUpdate("INSERT OR REPLACE INTO Photo (url, feedTheme, pubDate) VALUES (:url, :feedTheme, :pubDate);", withParameterDictionary: paramsDictionary)
                        
                        if !success {
                            transactionFailed = true
                            rollback.initialize(to: true)
                            break
                        }
                    }
                }
                
                if transactionFailed {
                    seal.reject(NSError(domain: kPhotoRepositoryErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Save photos in database failed"]))
                } else {
                    seal.fulfill(true)
                }
            }
        }
    }
    
    func getPhotosFor(feedTheme: FeedTheme) -> Promise<[Photo]> {
        return Promise { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                var items = [Photo]()
                self.queue.inDatabase { db in
                    if let resultSet = db.executeQuery("SELECT * FROM Photo WHERE feedTheme = ?", withArgumentsIn: [feedTheme.rawValue]) {
                        while resultSet.next() {
                            guard let url = resultSet.string(forColumn: "url") else { continue }
                            guard let pubDate = resultSet.string(forColumn: "pubDate") else { continue }
                            if let photo = Photo(url: url, publicationDate: pubDate, isFavorite: resultSet.bool(forColumn: "isFavorite")) {
                                items.append(photo)
                            }
                        }
                    }
                }
                
                seal.fulfill(items)
            }
        }
    }
    
    // MARK: Helpers
    // TODO
    private func hashOf(value: String) -> Int {
        return 0
    }
    
    
}




