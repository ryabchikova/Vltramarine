//
//  Photo.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

class Photo: NSObject {
    
    let identifier: Int
    let url: URL
    let publicationDate: Date
    let isFavorite: Bool
    
    init(identifier: Int, url: URL, publicationDate: Date, isFavorite: Bool = false) {
        self.identifier = identifier
        self.url = url
        self.publicationDate = publicationDate
        self.isFavorite = isFavorite
    }
}
