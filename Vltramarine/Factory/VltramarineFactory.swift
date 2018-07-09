//
//  VltramarineFactory.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 03/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit

class VltramarineFactory {
    
    static private var databaseProvider: DatabaseProvider?     // singleton behavior
    
    static var configuration: [String: Any] = getConfiguration(fromPlist: "Configuration", in: Bundle.main)
    
    // MARK: Viewcontrollers
    
    static func makeFeedViewController() -> FeedViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        feedViewController.photoService = makePhotoService()
        return feedViewController
    }
    
    static func makeFullScreenPhotoViewController() -> FullScreenPhotoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FullScreenPhotoViewController") as! FullScreenPhotoViewController
    }
    
    // MARK: Viewmodels
    
    static func makeMenuViewModel() -> MenuViewModel {
        return MenuViewModel()
    }
    
    // MARK: DAO
    
    static func makeDatabaseProvider() -> DatabaseProvider {
        
        if let provider = self.databaseProvider { return provider }
        
        let dbFileName = (self.configuration["database_file_name"]  as? String) ?? ""
        if (dbFileName.isEmpty) {
            fatalError("Confiiguration error: database file name is empty.")
        }
        
        let docPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let provider = DatabaseProvider(dataBasePath: (docPaths[0] as NSString).appendingPathComponent(dbFileName) as String)
        self.databaseProvider = provider
        return provider
    }
    
    static func makePhotoRepository() -> PhotoRepository {
        let databaseProvider = makeDatabaseProvider()
        return PhotoRepositorySQLiteImpl(databaseProvider: databaseProvider)
    }
    
    static func makePhotoService() -> PhotoService {
        let repository = makePhotoRepository()
        return PhotoServiceImpl(repository: repository)
    }
    
    
    
}
