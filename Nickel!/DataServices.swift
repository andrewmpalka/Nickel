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
            employeeRef.childByAppendingPath(name).setValue(["status": status])
        }
    }
    
    class func listenForEmployeeUpdates() {
        let ref = Firebase(url: "\(nickelEmployees)/employee")
        
        ref.queryOrderedByChild("employeeName").observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            for employee in snapshot.children {
                print("---> \(employee.key)")
            }
            }) { (error) -> Void in
                print(error.description)
        }
    }
    
}
