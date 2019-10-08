//
//  Person+CoreDataProperties.swift
//  date_dots
//
//  Created by Aaron Williamson on 9/12/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//
//

import Foundation
import CoreData

extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var birthdate: Date?
    @NSManaged public var anniversary: Date?
}
