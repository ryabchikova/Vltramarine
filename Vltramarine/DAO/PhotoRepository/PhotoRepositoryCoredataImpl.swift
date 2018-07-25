//
//  PhotoRepositoryCoredataImpl.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 25/07/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import PromiseKit
import CoreData

class PhotoRepositoryCoredataImpl: PhotoRepository {
    
    private let managedContext: NSManagedObjectContext

    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    // TODO insert if not exist
    func savePhotosFor(feedTheme: FeedTheme, photos: [PhotoXmlData]) -> Promise<Void> {
        return Promise { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                for xmlData in photos {
                    let entity = NSEntityDescription.entity(forEntityName: "Photo", in: self.managedContext)!
                    let photo = Photo(entity: entity, insertInto: self.managedContext)
                    photo.identifier = Int32(xmlData.identifier)
                    photo.url = xmlData.url.absoluteString
                    photo.publicationDate = xmlData.publicationDate as NSDate
                    photo.feedTheme = Int16(feedTheme.rawValue)
                }
                do {
                    try self.managedContext.save()
                    seal.fulfill(())
                } catch {
                    seal.reject(NSError(domain: kPhotoRepositoryErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Save photos in Coredata failed"]))
                }
            }
        }
    }
    
    func getPhotosFor(feedTheme: FeedTheme) -> Promise<[Photo]> {
        return Promise { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                let request = NSFetchRequest<Photo>(entityName: "Photo")
                request.predicate = NSPredicate(format: "feedTheme == %d", Int16(feedTheme.rawValue))
                request.sortDescriptors = [NSSortDescriptor(key: "publicationDate", ascending: false)]
                do {
                    let photos = try self.managedContext.fetch(request)
                    seal.fulfill(photos)
                } catch {
                    seal.reject(NSError(domain: kPhotoRepositoryErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Get photos from Coredata failed"]))
                }
            }
        }
    }
    
    func setFavoriteStateForPhotoWith(identifier: Int, isFavorite: Bool) -> Guarantee<Bool> {
        return Guarantee { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                let request = NSFetchRequest<Photo>(entityName: "Photo")
                request.predicate = NSPredicate(format: "identifier == %d", Int32(identifier))
                do {
                    let result = try self.managedContext.fetch(request)
                    if let photo = result.first {
                        photo.isFavorite = isFavorite
                        try self.managedContext.save()
                    }
                    seal(true)
                } catch {
                    seal(false)
                }
            }
        }
    }
    
    // TODO test
    func deleteAllPhotos() -> Guarantee<Bool> {
        return Guarantee { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                let request = NSFetchRequest<Photo>(entityName: "Photo")
                request.includesPropertyValues = false
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
                do {
                    try self.managedContext.execute(batchDeleteRequest)
                    seal(true)
                } catch {
                    seal(false)
                }
            }
        }
    }
}
