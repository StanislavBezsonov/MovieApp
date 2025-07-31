//
//  SavedMovie+CoreDataProperties.swift
//  MovieApp
//
//  Created by Stanislav Bezsonov on 31/07/2025.
//
//

import Foundation
import CoreData


extension SavedMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMovie> {
        return NSFetchRequest<SavedMovie>(entityName: "SavedMovie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var listType: String

}

extension SavedMovie : Identifiable {

}

extension SavedMovie {
    var list: CustomerListType {
        get {
            CustomerListType(rawValue: listType) ?? .wishlist
        }
        set {
            listType = newValue.rawValue
        }
    }
}
