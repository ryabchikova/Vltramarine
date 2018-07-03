//
//  ObjectFactory.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 03/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

protocol ObjectFactory {
    
    static func makeMenuViewModel() -> MenuViewModel
    
    static func makeFeedViewController() -> FeedViewController
    
    static func makePhotoService() -> PhotoService
    
    static func makePhotoRepository() -> PhotoRepository
    
}
