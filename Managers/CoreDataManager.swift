//
//  CoreDataManager.swift
//  date_dots
//
//  Created by Aaron Williamson on 9/11/19.
//  Copyright © 2019 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

// Manages the persistence of Contacts
class CoreDataManager {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("loadPersistentStores error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let nserror as NSError {
            print("saveContext error: \(nserror), \(nserror.userInfo)")
        }
    }
}
