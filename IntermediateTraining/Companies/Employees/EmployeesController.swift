//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by Donald McAllister on 9/18/19.
//  Copyright © 2019 Donald McAllister. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    var company: Company?
    
    var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
        
        
    }
    
    private func fetchEmployees() {
        //        company?.employees //type NSSet?
        //        self.employees //different type, here is how to connect these two:
       
        // self.employees = company?.employees?.allObjects as! [Employee]
        // better without force unwrap:
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
        self.employees = companyEmployees
        
//        print("Trying to fetch employees")
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//
//        let request = NSFetchRequest<Employee>(entityName: "Employee")
//
//        do {
//            let employees = try context.fetch(request)
//            self.employees = employees
//           // employees.forEach{print("Employee name: ", $0.name ?? "")}
//        } catch let err {
//            print("failed to fetch employees: ", err)
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        
        if let taxId = employee.employeeInformation?.taxId {
            cell.textLabel?.text = "\(employee.name ?? "") \(taxId)"
        }
        
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    let cellId =  "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEmployees()
        
        tableView.backgroundColor = .darkBlue
        
       setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc private func handleAdd() {
        print("trying to add an employee")
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company 
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    
    }
}
