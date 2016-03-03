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
            ref.setValue(name)
            ref.childByAutoId().setValue(["name": name, "status": status])
        }
    }
    
    class func listenForEmployeeUpdates(completionHandler: (employees: [EmployeeObj]) -> Void) {
        let ref = Firebase(url: nickelEmployees)
        ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            var employees = [EmployeeObj]()
            
            for employee in snapshot.children.allObjects as! [FDataSnapshot] {
                if let map = employee.value as? [String: AnyObject] {
                    employees.append(EmployeeObj(name: map["name"] as! String, status: map["status"] as! String))
                }
            }

            completionHandler(employees: employees)
            
            }) { (error) -> Void in
                print(error.description)
        }
    }
    
}
