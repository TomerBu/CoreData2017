//
//  Phone+CoreDataProperties.swift
//  CoreDataDemos
//
//  Created by Tomer Buzaglo on 02/11/2017.
//  Copyright © 2017 Tomer Buzaglo. All rights reserved.
//
//

import Foundation
import CoreData


extension Phone {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Phone> {
        return NSFetchRequest<Phone>(entityName: "Phone")
    }

    @NSManaged public var number: String?
    @NSManaged public var owner: Person?

}
