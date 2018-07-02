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
                    identifier INTEGER PRIMARY KEY,
                    url TEXT,
                    publicationDate INTEGER,
                    feedTheme INTEGER,
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
    
    func savePhotosFor(feedTheme: FeedTheme, photos: [Photo]) -> Promise<Void> {
        return Promise { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                var transactionFailed = false
                self.queue.inTransaction { db, rollback in
                    for item in photos {
                        let paramsDictionary: [AnyHashable: Any] = [
                            "identifier": item.identifier,
                            "url": item.url.absoluteString,
                            "publicationDate": item.publicationDate.timeIntervalSince1970,
                            "feedTheme": feedTheme.rawValue
                        ]
                        
                        let success = db.executeUpdate("INSERT OR IGNORE INTO Photo (identifier, url, publicationDate, feedTheme) VALUES (:identifier, :url, :publicationDate, :feedTheme);", withParameterDictionary: paramsDictionary)
                        
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
                    seal.fulfill(())
                }
            }
        }
    }
    
    func getPhotosFor(feedTheme: FeedTheme) -> Guarantee<[Photo]> {
        return Guarantee { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                var items = [Photo]()
    
                var query = ""
                switch feedTheme {
                case .favorites:
                    query = "SELECT * FROM Photo WHERE isFavorite = 1 ORDER BY publicationDate DESC;"
                default:
                    query = "SELECT * FROM Photo WHERE feedTheme = \(feedTheme.rawValue) ORDER BY publicationDate DESC;"
                }
                
                self.queue.inDatabase { db in
                    if let resultSet = db.executeQuery(query, withArgumentsIn: []) {
                        while resultSet.next() {
                            let identifier = Int(resultSet.int(forColumn: "identifier"))
                            guard let urlString = resultSet.string(forColumn: "url") else { continue }
                            guard let url = URL(string: urlString) else { continue }
                            guard let pubDate = resultSet.date(forColumn: "publicationDate") else { continue }
                            let isFavorite = resultSet.bool(forColumn: "isFavorite")
                            items.append(Photo(identifier: identifier, url: url, publicationDate: pubDate, isFavorite: isFavorite))
                        }
                    }
                }
                
                seal(items)
            }
        }
    }
    
    func setFavoriteStateForPhotoWith(identifier: Int, isFavorite: Bool) -> Guarantee<Bool> {
        return Guarantee { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                self.queue.inDatabase { db in
                    seal(db.executeUpdate("UPDATE Photo SET isFavorite = ? WHERE identifier = ?",
                                                  withArgumentsIn: [(isFavorite ? 1 : 0), identifier]))
                }
            }
        }
    }
}
