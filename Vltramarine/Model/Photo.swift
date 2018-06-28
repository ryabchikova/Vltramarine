//
//  Photo.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 27/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

class Photo: NSObject {
    let url: String
    let publicationDate: Date
    
    init?(url: String, publicationDate: String) {
        guard !url.isEmpty else {return nil}
        self.url = url
        
        let formatter = DateFormatter()
                                
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
        // TODO доделать формат
        //guard let pubDate = formatter.date(from: publicationDate) else {return nil}
        
        if let pubDate = formatter.date(from: publicationDate) {
            self.publicationDate = pubDate
        } else {
            self.publicationDate = Date()
        }
    }
}
