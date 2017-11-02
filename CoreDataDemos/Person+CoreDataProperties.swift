//
//  Person+CoreDataProperties.swift
//  CoreDataDemos
//
//  Created by Tomer Buzaglo on 02/11/2017.
//  Copyright © 2017 Tomer Buzaglo. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var email: String?
    @NSManaged public var imageData: NSData?

}
