//
//  PhotoService.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import PromiseKit

protocol PhotoService {
    
    func getAllPhotosFrom(feed: Feed) -> Promise<[Photo]>
    
    func setFavoriteStateForPhotoWith(identifier: Int, isFavorite: Bool) -> Guarantee<Bool>
}
