//
//  DatabaseProvider.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 08/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

import Foundation
import FMDB

class DatabaseProvider {
    
    let queue: FMDatabaseQueue
    let dbPath: String
    
    init(dataBasePath: String) {
        guard !dataBasePath.isEmpty else {
            fatalError("Setup database failed. Error: database file name is empty.")
        }
        
        self.dbPath = dataBasePath
        self.queue = FMDatabaseQueue(path: dataBasePath)
        self.setupDatabase()
    }
    
    private func setupDatabase() {
        self.queue.inDatabase { db in
            let query = """
                CREATE TABLE IF NOT EXISTS Photo (
                    identifier INTEGER PRIMARY KEY,
                    url TEXT,
                    publicationDate INTEGER,
                    feedTheme INTEGER,
                    isFavorite INTEGER DEFAULT 0)
            """
            if !db.executeUpdate(query, withArgumentsIn: []) {
                fatalError("Setup database \(self.dbPath) failed. Error: \(db.lastErrorMessage())")
            }
        }
    }
}


// Singleton
//class DatabaseProvider {
//
//    class func shared() -> DatabaseProvider {
//        return sharedDatabaseProvider
//    }
//
//    let queue: FMDatabaseQueue
//    let dbPath: String
//
//    private static var sharedDatabaseProvider: DatabaseProvider = {
//        let configuration = getConfiguration(for: Bundle.)
//        guard let dbFileName = (configuration["database_file_name"]  as? String) else { return DatabaseProvider(dataBasePath: "") }
//
//        let docPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        return DatabaseProvider(dataBasePath: (docPaths[0] as NSString).appendingPathComponent(dbFileName) as String)
//    }()
//
//    private init(dataBasePath: String) {
//        guard !dataBasePath.isEmpty else {
//            fatalError("Setup database failed. Error: database file name is empty.")
//        }
//
//        self.dbPath = dataBasePath
//        self.queue = FMDatabaseQueue(path: dataBasePath)
//        self.setupDatabase()
//    }
//
//    private func setupDatabase() {
//        self.queue.inDatabase { db in
//            let query = """
//                CREATE TABLE IF NOT EXISTS Photo (
//                    identifier INTEGER PRIMARY KEY,
//                    url TEXT,
//                    publicationDate INTEGER,
//                    feedTheme INTEGER,
//                    isFavorite INTEGER DEFAULT 0)
//            """
//            if !db.executeUpdate(query, withArgumentsIn: []) {
//                fatalError("Setup database \(self.dbPath) failed. Error: \(db.lastErrorMessage())")
//            }
//        }
//    }
//}
