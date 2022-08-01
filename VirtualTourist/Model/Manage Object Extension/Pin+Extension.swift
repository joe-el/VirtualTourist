//
//  Pin+Extension.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 6/30/22.
//

import CoreData
import Foundation

extension Pin {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photos: NSSet?
}

extension Pin {
    // generated accessors for photos
    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
}

extension Pin: Identifiable { }

//extension Pin {
//    public override func awakeFromInsert() {
//        super.awakeFromInsert()
//        creationDate = Date()
//    }
//}
