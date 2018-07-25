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
    
    func savePhotosFor(feedTheme: FeedTheme, photos: [PhotoXmlData]) -> Promise<Void>
    
    func getPhotosFor(feedTheme: FeedTheme) -> Promise<[Photo]>
 
    func setFavoriteStateForPhotoWith(identifier: Int, isFavorite: Bool) -> Guarantee<Bool>
    
    func deleteAllPhotos() -> Guarantee<Bool>
}
