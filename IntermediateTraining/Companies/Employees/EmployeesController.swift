//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by Donald McAllister on 9/18/19.
//  Copyright © 2019 Donald McAllister. All rights reserved.
//

import UIKit
import CoreData

// lets create a UILabel subclass for custom text drawing
class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    //remember this is called when dismiss employee creation
    func didAddEmployee(employee: Employee) {
//        employees.append(employee)
        // fetchEmployees()
       // tableView.reloadData()
        
        //what is the insertion index path since we want to animate the addition:
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at:[insertionIndexPath], with: .middle)
    }
    
    var company: Company?
    
    var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
//        if section == 0 {
//            label.text = EmployeeType.Executive.rawValue
//        } else  if section == 1 {
//            label.text = EmployeeType.SeniorManagement.rawValue
//        } else {
//            label.text = EmployeeType.Staff.rawValue
//        }
//
        label.text = employeeTypes[section]
        
        label.textColor = UIColor.darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.lightBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
       // self.employees = companyEmployees
        
        allEmployees = [] // to fix bug from earlier
        
        //let's use my array and loop to filter instead:
        employeeTypes.forEach { (employeeType) in
            //somehow construct allEmployees array
            allEmployees.append(companyEmployees.filter{$0.type == employeeType})
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            cell.textLabel?.text = "\(employee.name ?? "") \(dateFormatter.string(from: birthday))"
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
