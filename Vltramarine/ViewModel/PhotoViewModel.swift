//
//  PhotoViewModel.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 03/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation

class PhotoViewModel: NSObject {
    
    let identifier: Int
    let url: URL
    let publicationDate: String
    var isFavorite: Bool
    
    init?(_ photo: Photo) {
        self.identifier = Int(photo.identifier)
        guard let urlString = photo.url, let url = URL(string: urlString) else { return nil }
        self.url = url
        guard let publicationDate = photo.publicationDate else  { return nil }
        self.publicationDate = PhotoViewModel.readableFormatFor(date: publicationDate as Date)
        self.isFavorite = photo.isFavorite
    }
    
    private class func readableFormatFor(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "dd MMM yyyy 'at' HH:mm"
        return formatter.string(from: date)
    }
}
