//
//  MenuViewModel.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

struct MenuItem {
    let feedTheme: FeedTheme
    let title: String
}

class MenuViewModel {
    let items: [MenuItem]
    
    init() {
        items = [MenuItem(feedTheme: .art, title: "Art"),
                 MenuItem(feedTheme: .design, title: "Design"),
                 MenuItem(feedTheme: .graffiti, title: "Graffiti"),
                 MenuItem(feedTheme: .streetart, title: "Street art"),
                 MenuItem(feedTheme: .urban, title: "Urban culture"),
                 MenuItem(feedTheme: .favorites, title: "Favorites"),
        ];
    }
}
