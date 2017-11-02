//
//  DBManager.swift
//  UserDefaultsDemo
//
//  Created by Tomer Buzaglo on 02/11/2017.
//  Copyright © 2017 Tomer Buzaglo. All rights reserved.
//

import CoreData

fileprivate let instance = DBManager()

class DBManager: NSObject { //inherit from NSObject allows us to "listen" to kvo
    
    //MARK: Signleton, Computed
    public class var shared: DBManager{return instance}
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreDataDemos")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Gotohell")
            }
        })
        return container
    }()
    
    //computed property for context:
    internal var context:NSManagedObjectContext{return persistentContainer.viewContext}
    
    // MARK: - Public API
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                
                
                

   
            }
        }
    }
    
    private func deleteTheDB(){
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let storeURL = docs.appendingPathComponent("Database.sqlite")
        
        try! FileManager.default.removeItem(at: storeURL)//.removeItemAtPath(storeURL.path, error)
    }
    
    public func getPepoleOrCrash() -> [Person] {
        do{
            return try context.fetch(Person.fetchRequest())
        }
        catch let e{
            print(e.localizedDescription)
            deleteTheDB()
            return []
        }
    }
    
    public func getPepole() throws -> [Person] {
        return try context.fetch(Person.fetchRequest())
    }
    
    public func addPerson(p: Person){
        //the user does not know how this class works. it's abstraction.
        //we may switch to Some other persistence mechanisms later
        //and the user will be ignorant about that fact.
        saveContext()
    }
}

