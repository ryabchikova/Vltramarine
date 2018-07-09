//
//  PhotoServiceImpl.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import PromiseKit

class PhotoServiceImpl: PhotoService {
    
    private let repository: PhotoRepository
    
    init(repository: PhotoRepository) {
        self.repository = repository
    }
    
    func getAllPhotosFrom(feed: Feed) -> Promise<[Photo]> {
        
        if feed.theme == .favorites {
            return Promise { seal in
                firstly {
                    self.repository.getPhotosFor(feedTheme: .favorites)
                }.done { photos in
                    seal.fulfill(photos)
                }.catch { error in
                    seal.reject(error)
                }
            }
        }

        return Promise { seal in
            firstly {
                self.getPhotosFromRssFor(feed: feed)
            }.then { photos in
                self.repository.savePhotosFor(feedTheme: feed.theme, photos: photos)
            }.then {
                self.repository.getPhotosFor(feedTheme: feed.theme)
            }.done { photos in
                seal.fulfill(photos)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func setFavoriteStateForPhotoWith(identifier: Int, isFavorite: Bool) -> Guarantee<Bool> {
        return self.repository.setFavoriteStateForPhotoWith(identifier:identifier, isFavorite:isFavorite)
    }
    
    private func getPhotosFromRssFor(feed: Feed) -> Promise<[Photo]> {
        return Promise { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let photos = try FeedXMLParser().getAllPhotosFrom(feedUrl: feed.url)
                    seal.fulfill(photos)
                } catch {
                    seal.reject(error)
                }
            }
        }
    }
    
}
