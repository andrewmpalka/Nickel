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
            ref.childByAppendingPath(name).setValue(["name": name, "status": status])
        }
    }
    
    class func listenForEmployeeUpdates(completionHandler: (employees: [EmployeeObj]) -> Void) {
        let ref = Firebase(url: "\(nickelEmployees)/\(User.sharedInstance.name!)")
        ref.queryOrderedByChild("employeeName").observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            var employees = [EmployeeObj]()

            if  let name = snapshot?.value.objectForKey("name") as? String,
                let status = snapshot?.value.objectForKey("status") as? String {
                employees.append(EmployeeObj(name: name, status: status))
            }
            
            
            completionHandler(employees: employees)
            
            }) { (error) -> Void in
                print(error.description)
        }
    }
    
}
