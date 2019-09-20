//
//  ViewController.swift
//  CoreData
//
//  Created by Donald McAllister on 9/16/19.
//  Copyright © 2019 Donald McAllister. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    @objc private func doWork() {
        print("Trying to do work...")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                
                //back on main
                DispatchQueue.main.async {
                     self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData() //doesn't work alone just yet because need to fetch first above
                }
            } catch let err {
                print("Failed to save:", err)
            }
            
        })
        
    }
    
    func addCompany(company: Company) {
      //  let tesla = Company(name: "Tesla", founded: Date())
        // 1 - modify array
        companies.append(company)
        // 2 - insert new indexPath into tableView
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    // let's do some tricky update with core data, like when downloading from server so UI doesn't freeze
    @objc private func doUpdate() {
        print("Trying to update companies on a background context")
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            
            //don't want to get companies from main thread, so new fetch:
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "A: \(company.name ?? "")"
                })
                
                do {
                    try  backgroundContext.save()
                    
                    //let's try to update UI after save:
                    //but fetch request here on background context is not aware of changes on main context
                    //reset on viewContext will forget all objects you've fetched before, especially in cases where updates done two only a select few
                    //need to merge changes, by putting updates on child context instead: doNestedUpdates()
                    
                    
                } catch let saveErr {
                    print("save error on background: ", saveErr)
                }
                
            } catch let err {
                print("Failed to fetch companies on background: ", err)
            }
            
        }
    }
    
    @objc private func doNestedUpdates() {
        print("Trying to perform nested updates now..")
        
        DispatchQueue.global(qos: .background).async {
            //we'll try to perform out updates
            
            //we'll first construct a custom MOC - Managed Object context
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            //execute updates on privateContext now
            let request:NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableView.reloadData() //this alone doesn't persist the changes back on main context.. above lines will get it to work: the changes will propagate updwards to parent
                            // problem is any sibling child context unaware of these changes.. to address next.
                            
                        } catch let saveErr {
                            print("failed to persist save on main context: ", saveErr)
                        }
                        
                       
                    }
                } catch let saveErr {
                    print("failed to save on private context: ", saveErr)
                }
                
            } catch let fetchErr {
                print("failed to fetch on private context: ", fetchErr)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        // remember have to reload tableview if outside of viewDidLoad
        
        // fetchCompanies()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        // tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView() // blank UIView
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
        ]
        
    }
    
    @objc private func handleReset() {
        print("attempting to delete all core data objects")
        let context = CoreDataManager.shared.persistentContainer.viewContext

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)

        } catch let delErr {
            print("failed to delete objects from Core Data: ", delErr)
        }
        
    }
    
private func fetchCompanies() {
    }
    
    @objc func handleAddCompany() {
        print("Adding company...")
        
        let createCompanyController = CreateCompanyController()
   
        createCompanyController.delegate = self
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        present(navController, animated: true, completion: nil)
        
    }
    
  
   
}

