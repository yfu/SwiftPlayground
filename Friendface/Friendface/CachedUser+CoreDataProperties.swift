//
//  CachedUser+CoreDataProperties.swift
//  Friendface
//
//  Created by Yu Fu on 2/19/22.
//
//

import Foundation
import CoreData


extension CachedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedUser> {
        return NSFetchRequest<CachedUser>(entityName: "CachedUser")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: String?
    @NSManaged public var friendUUIDs: String?

    var unWrappedID: UUID {
        get {
            id ?? UUID()
        }
    }
    var unWrappedName: String {
        get {
            name ?? "No name"
        }
        set {
            name = newValue
        }
    }
    
    var unWrappedCompany: String {
        get {
            company ?? "No company"
        }
        set {
            company = newValue
        }
    }
    
    var unWrappedEmail: String {
        get {
            email ?? "No email"
        }
        set {
            email = newValue
        }
    }
    
    var unWrappedAddress: String {
        get {
            address ?? "No email"
        }
        set {
            address = newValue
        }
    }
    
    var unWrappedAbout: String {
        get {
            about ?? "Empty about"
        }
        set {
            about = newValue
        }
    }
    
    var unWrappedRegistered: Date {
        get {
            registered ?? Date.distantPast
        }
        set {
            registered = newValue
        }
    }
    
    var unWrappedTags: [String] {
        get {
            tags?.components(separatedBy: CharacterSet(charactersIn: ",")) ?? ["Tag unavailable"]
        }
        set {
            tags = newValue.joined(separator: ",")
        }
    }
    
    // Note that UUIDs of friends are stored, instead of actual Friend object
    var unWrappedFriendUUIDs: [UUID] {
        get {
            friendUUIDs?.components(separatedBy: ",").map {
                UUID(uuidString: $0)!
            } ?? [UUID()]
        }
        set {
            friendUUIDs = newValue.map {
                $0.uuidString
            }.joined(separator: ",")
        }
    }
}

extension CachedUser : Identifiable {

}
