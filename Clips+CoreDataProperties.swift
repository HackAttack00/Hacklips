//
//  Clips+CoreDataProperties.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/04/02.
//
//

import Foundation
import CoreData


extension Clips {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Clips> {
        return NSFetchRequest<Clips>(entityName: "Clips")
    }

    @NSManaged public var pastedText: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var pinned: Bool

}

extension Clips : Identifiable {

}
