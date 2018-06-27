//
//  MenuViewModel.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

struct MenuItem {
    let feed: Feed
    let title: String
}

class MenuViewModel {
    let items: [MenuItem]
    
    init() {
        items = [MenuItem(feed: .art, title: "Art"),
                 MenuItem(feed: .design, title: "Design"),
                 MenuItem(feed: .graffiti, title: "Graffiti"),
                 MenuItem(feed: .streetart, title: "Street art"),
                 MenuItem(feed: .urban, title: "Urban culture"),
                 MenuItem(feed: .favorites, title: "Favorites"),
        ];
    }
}
