//
//  Photo.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import UIKit

class Photo: NSObject {
    let url: URL
    let publicationDate: String
    let isFavorite: Bool
    
    init?(url: String, publicationDate: String, isFavorite: Bool = false) {
        
        guard let photoUrl = URL(string: url) else { return nil }
        self.url = photoUrl
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
//        guard let pubDate = formatter.date(from: publicationDate) else { return nil }
        guard !publicationDate.isEmpty else { return nil }
        self.publicationDate = publicationDate
        
        self.isFavorite = isFavorite
    }
}
