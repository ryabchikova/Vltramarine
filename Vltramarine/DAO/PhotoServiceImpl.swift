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
    
    var repository: PhotoRepository!
    
    func getAllPhotosFrom(feed: Feed) -> Promise<[Photo]> {
        
        if feed.theme == .favorites {
            return self.getFavorites()
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
    
    private func getFavorites() -> Promise<[Photo]> {
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
    
    
    private func getPhotosFromRssFor(feed: Feed) -> Promise<[Photo]> {
        return Promise { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                seal.fulfill(FeedXMLParser().getAllPhotosFrom(feedUrl: feed.url).compactMap { item -> Photo? in
                    return Photo(url: item.url, publicationDate: item.pubDate)
                })
            }
        }
    }
    
}
