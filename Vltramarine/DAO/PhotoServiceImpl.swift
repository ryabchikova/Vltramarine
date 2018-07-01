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
    
    func getAllPhotosFrom(feed: Feed) -> Promise<[Photo]> {
        return Promise { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                seal.fulfill(FeedXMLParser().getAllPhotosFrom(feedUrl: feed.url).compactMap { item -> Photo? in
                    return Photo(url: item.url, publicationDate: item.pubDate)
                })
            }
        }
    }
    
}
