//
//  VltramarineFactory.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 03/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit

class VltramarineFactory: ObjectFactory {

    static func makeMenuViewModel() -> MenuViewModel {
        return MenuViewModel()
    }
    
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
    
    static func makePhotoService() -> PhotoService {
        let photoService = PhotoServiceImpl()
        photoService.repository = makePhotoRepository()
        return photoService
    }
    
    static func makePhotoRepository() -> PhotoRepository {
        let docPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return PhotoRepositorySQLiteImpl(dataBasePath: (docPaths[0] as NSString).appendingPathComponent("Vltramarine.sqlite") as String)
    }
}
