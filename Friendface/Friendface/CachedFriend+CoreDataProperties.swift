//
//  CachedFriend+CoreDataProperties.swift
//  Friendface
//
//  Created by Yu Fu on 2/19/22.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}

extension CachedFriend : Identifiable {

}
