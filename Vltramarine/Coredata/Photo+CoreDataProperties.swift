//
//  Photo+CoreDataProperties.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 25/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var identifier: Int32
    @NSManaged public var url: String?
    @NSManaged public var publicationDate: NSDate?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var feedTheme: Int16

}
