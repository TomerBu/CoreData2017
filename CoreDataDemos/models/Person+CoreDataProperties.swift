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
    @NSManaged public var phone: NSSet?

}

// MARK: Generated accessors for phone
extension Person {

    @objc(addPhoneObject:)
    @NSManaged public func addToPhone(_ value: Phone)

    @objc(removePhoneObject:)
    @NSManaged public func removeFromPhone(_ value: Phone)

    @objc(addPhone:)
    @NSManaged public func addToPhone(_ values: NSSet)

    @objc(removePhone:)
    @NSManaged public func removeFromPhone(_ values: NSSet)

}
