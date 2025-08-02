//
//  IgnoredMovie+CoreDataProperties.swift
//  MovieApp
//
//  Created by Stanislav Bezsonov on 02/08/2025.
//
//

import Foundation
import CoreData


extension IgnoredMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IgnoredMovie> {
        return NSFetchRequest<IgnoredMovie>(entityName: "IgnoredMovie")
    }

    @NSManaged public var id: Int64

}

extension IgnoredMovie : Identifiable {

}
