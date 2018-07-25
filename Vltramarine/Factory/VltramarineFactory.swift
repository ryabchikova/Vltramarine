//
//  VltramarineFactory.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 03/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class VltramarineFactory {
    
    static private let configuration: [String: Any] = getConfiguration(fromPlist: "Configuration", in: Bundle.main)
    
    static private let managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate  as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
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
    
    static func makePhotoRepository() -> PhotoRepository {
        return PhotoRepositoryCoredataImpl(managedContext: self.managedContext)
    }
    
    static func makePhotoService() -> PhotoService {
        let repository = makePhotoRepository()
        return PhotoServiceImpl(repository: repository)
    }
    
    
    
}
