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
    let identifier: Int
    let url: URL
    let publicationDate: Date
    let isFavorite: Bool
    
    init?(url: String, publicationDate: Date, isFavorite: Bool = false) {
        
        // get identifier
        let firstRange = url.range(of: "photos/")
        let secondRange = url.range(of: "/images")
        if firstRange != nil && secondRange != nil {
            self.identifier = (String(url[firstRange!.upperBound..<secondRange!.lowerBound]) as NSString).integerValue
        } else {
            return nil
        }
        
        guard let photoUrl = URL(string: url) else { return nil }
        self.url = photoUrl
        
        self.publicationDate = publicationDate
        self.isFavorite = isFavorite
    }
}
