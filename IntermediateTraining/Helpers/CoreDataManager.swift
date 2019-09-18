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
    
    func fetchCompanies() -> [Company] {
        
            let context = persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
            
            do {
                let companies = try context.fetch(fetchRequest)
                
                return companies // what we need to return
            
                }
                
             catch let fetchErr {
                print("Failed to fetch companies: ", fetchErr)
                
                return [] // need to return something
            }
    }
    
    func createEmployee(employeeName: String) -> Error? {
        let context = persistentContainer.viewContext
        
        //create an employee
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        
        employee.setValue(employeeName, forKey: "name")
        do {
            try context.save()
            return nil
        } catch let err {
            print("Failed to crate employee: ", err)
            return err
        }
    }
}
