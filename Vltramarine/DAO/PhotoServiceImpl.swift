//
//  PhotoServiceImpl.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import PromiseKit
import SWXMLHash

class PhotoServiceImpl: NSObject, PhotoService {
    
    func getPhotosFrom(feed: Feed) -> AnyPromise {
        
        let promise = Promise<[Photo]?> { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                seal.fulfill(FeedXMLParser().getAllPhotosFrom(feedUrl: feed.url))
            }
        }
            
        return AnyPromise(promise)
    
        /*
        guard let feedUrl = URL(string: feed.url) else { return }

        firstly {
            URLSession.shared.dataTask(.promise, with: URLRequest(url: feedUrl))
        }.compactMap(on: DispatchQueue.global(qos: .userInteractive)) { data, _ in
            let xml = SWXMLHash.parse(data)
            let descriptions = xml["channel"]["item"]["description"].all.map{ elem in
                elem.element!.text
            }
        }
 */
   
    }
}
