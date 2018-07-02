//
//  PhotoRepository.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 01/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import PromiseKit

protocol PhotoRepository {
    
    func savePhotosFor(feedTheme: FeedTheme, photos: [Photo]) -> Promise<Void>
    
    func getPhotosFor(feedTheme: FeedTheme) -> Guarantee<[Photo]>
 
    func setFavoriteStateForPhotoWith(identifier: Int, isFavorite: Bool) -> Guarantee<Bool>
}
