//
//  DataServices.swift
//  Nickel!
//
//  Created by Jonathan Kilgore on 3/2/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Firebase

class DataServices {
    
    static let nickelEmployees = "https://nickelapp.firebaseio.com/nickelData/employees"
    
    class func updateFirebaseEmployee(status: String) {
        
        let ref = Firebase(url: nickelEmployees)
        if let name = User.sharedInstance.name {
            let employeeRef = ref.childByAppendingPath("employee")
            employeeRef.childByAppendingPath(name).childByAutoId().setValue(["status": status])
        }
    }
    
    class func listenForEmployeeUpdates(completionHandler: (employees: [EmployeeObj]) -> Void) {
        let ref = Firebase(url: "\(nickelEmployees)/employee")
        ref.queryOrderedByChild("employeeName").observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            var employees = [EmployeeObj]()
            for employee in snapshot.children {
                employees.append(EmployeeObj(name: employee["name"] as! String, status: employee["status"] as! String))
            }
            
            completionHandler(employees: employees)
            
            }) { (error) -> Void in
                print(error.description)
        }
    }
    
}
