//
//  FeedViewModel.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 28/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

//struct FeedItem {
//
//    let url: String
//    let pubDate: String
//    let isFavorite: Bool
//    let image: UIImage?     // TODO
//}

class FeedViewModel: NSObject {
    
//    var items: [FeedItem]
//    
//    private let feed: Feed
//    private let photoService: PhotoService
//    
//    
//    init(feed: Feed, photoService: PhotoService) {
//        
//        self.feed = feed
//        self.photoService = photoService
//        self.items = []
//    }
//    
//    //func updateData(completion: @escaping () -> Void) {
//    func updateData() {
//        _ = self.photoService.getXmlDataFrom(feed: self.feed).done { xmlData in
//            if let xmlData = xmlData {
//                self.items = xmlData.map { element -> FeedItem in
//                    FeedItem(url: element.url, pubDate: element.pubDate, isFavorite: false, image: nil)
//                }
//            }
//        }
//    }
    
    
//    func updateItems(completion: @escaping () -> Void) {
//        // should update items time to time, cause it's live content
//        // may be not on each call of this func
//
//        _ = self.photoService.getXmlDataFrom(feed: self.feed).done { data in
//            if let xmlData = data {
//                self.items = xmlData.map { element -> FeedItem in
//                    return FeedItem(url: element.url, pubDate: element.pubDate, isFavorite: false)
//                }
//            } else {
//                self.items = []
//            }
//
//            completion()
//        }
//    }
    
    
    
    
}
