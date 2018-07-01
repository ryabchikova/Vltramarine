//
//  Feed.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

enum FeedTheme: Int {
    
    case art = 0
    case design
    case graffiti
    case streetart
    case urban
    case favorites
}

// TODO feed's url place to constants or some config
class Feed: NSObject {
    
    let theme: FeedTheme
    let url: String
    
    init(feedTheme: FeedTheme) {
        self.theme = feedTheme
        
        switch feedTheme {
        case .art:
            self.url = "http://www.vltramarine.ru/feed/photos/3"
        case .design:
            self.url = "http://www.vltramarine.ru/feed/photos/4"
        case .graffiti:
            self.url = "http://www.vltramarine.ru/feed/photos/1"
        case .streetart:
            self.url = "http://www.vltramarine.ru/feed/photos/2"
        case .urban:
            self.url = "http://www.vltramarine.ru/feed/photos/5"
        case .favorites:
            self.url = ""
        }
    }
}


