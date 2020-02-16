//
//  PersistenceService.swift
//  projectiosfirebase
//
//  Created by User on 08/12/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    private init(){}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: {_,_ in })
        return container
        
    }()
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                //ERROR
            }
        }
    }
}
