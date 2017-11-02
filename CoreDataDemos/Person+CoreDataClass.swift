//
//  Person+CoreDataClass.swift
//  CoreDataDemos
//
//  Created by Tomer Buzaglo on 02/11/2017.
//  Copyright © 2017 Tomer Buzaglo. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {
    convenience init(email:String, image: Data?) {
        let context = DBManager.shared.context
        let desc = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        self.init(entity: desc, insertInto: context)
        
        self.email = email
        
        self.imageData = image as NSData?
//
//        //if let data = image as NSData
//        if let data = image {
//
//        }
    }
}
