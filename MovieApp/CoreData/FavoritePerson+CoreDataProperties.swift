//
//  FavoritePerson+CoreDataProperties.swift
//  MovieApp
//
//  Created by Stanislav Bezsonov on 01/08/2025.
//
//

import Foundation
import CoreData


extension FavoritePerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritePerson> {
        return NSFetchRequest<FavoritePerson>(entityName: "FavoritePerson")
    }

    @NSManaged public var id: Int64

}

extension FavoritePerson : Identifiable {

}
