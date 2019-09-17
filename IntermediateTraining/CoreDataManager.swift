//
//  CoreDataManager.swift
//  IntermediateTraining
//
//  Created by Donald McAllister on 9/17/19.
//  Copyright © 2019 Donald McAllister. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager() // variable is instance of this class and will live forever as long as application still alive, it's properties will too.
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntermediateTrainingModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        
        return container
    }()
}
