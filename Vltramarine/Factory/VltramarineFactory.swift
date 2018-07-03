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
        
        // another variant
        //return MenuViewModel(menuItems: [MenuItem(feedTheme: .art, title: "Art"), MenuItem(feedTheme: .urban, title: "Urban")])
    }
    
    static func makeFeedViewController() -> FeedViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        feedViewController.photoService = makePhotoService()
        return feedViewController
    }
    
    static func makePhotoService() -> PhotoService {
        let photoService = PhotoServiceImpl()
        photoService.repository = makePhotoRepository()
        return photoService
    }
    
    static func makePhotoRepository() -> PhotoRepository {
        return PhotoRepositorySQLiteImpl()
    }
    

}
