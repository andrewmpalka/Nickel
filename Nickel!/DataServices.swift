//
//  DataServices.swift
//  Nickel!
//
//  Created by Jonathan Kilgore on 3/2/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import Firebase

class DataServices {

    // method for timeStamp
    class func generateTimestamp() -> String {
        return  NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .ShortStyle)
    }


    static let nickelEmployees = "https://nickelapp.firebaseio.com/employees"
    static let nickelGroupMessages = "https://nickelapp.firebaseio.com/groupMessages"
    static let nickelPrivateMessages = "https://nickelapp.firebaseio.com/privateMessages"
    
    class func sendPrivateMessage(toUser: String, message: String) {
        let ref = Firebase(url: nickelPrivateMessages)
        if let name = User.sharedInstance.name {
            ref.childByAutoId().setValue(["from": name, "to": toUser, "message": message])
        }
    }
    
    class func listenForPrivateMessages(completionHandler: (messages: [MessageObj]) -> Void) {
        let ref = Firebase(url: nickelPrivateMessages)
        
        
        ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            var messages = [MessageObj]()
            
            print(snapshot)
            for message in snapshot.children.allObjects as! [FDataSnapshot] {
                if let map = message.value as? [String: AnyObject] {
                    if map["timestamp"] != nil {
                    let msg = MessageObj(name: map["from"] as! String, message: map["message"] as! String, timestamp: map["timestamp"] as! String)
                    messages.append(msg)
                    } else {
                        let msg = MessageObj(name: map["from"] as! String, message: map["message"] as! String, timestamp: "0:00 AM")
                    messages.append(msg)
                    }
}
//                else {
//                    let msg = MessageObj(name: map["from"] as! String, message: map["message"], timestamp: "0:00 AM")
//}
                
            }
            
            if let name = User.sharedInstance.name {
                completionHandler(messages: messages.filter( { $0.name == name || $0.from == name } ))
            }
            
            }) { (error) -> Void in
                print(error.description)
        }
        
    }
    
    class func sendGroupMessage(message: String) {
        let ref = Firebase(url: nickelGroupMessages)
        if let name = User.sharedInstance.name {
            ref.childByAutoId().setValue(["from": name, "message": message])
        }
    }
    
    class func listenForGroupMessages(completionHandler: (messages: [MessageObj]) -> Void)  {
        let ref = Firebase(url: nickelGroupMessages)
        ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            var messages = [MessageObj]()
            
            print(snapshot)
            for message in snapshot.children.allObjects as! [FDataSnapshot] {
                
                
                
                if let map = message.value as? [String: AnyObject] {
                    if map["timeStamp"] != nil {
                let msg = MessageObj(name: map["from"] as! String, message: map["message"] as! String, timestamp: map["timestamp"] as! String)
                    messages.append(msg)
                    } else {
                        let msg = MessageObj(name: map["from"] as! String, message: map["message"] as! String, timestamp: "0:00 AM")
                    messages.append(msg)
                    }
                } else {
                    let msg = MessageObj(name: "", message: "", timestamp: "0")
                    messages.append(msg)
                }
            }
            print(messages)
            completionHandler(messages: messages)
            
            }) { (error) -> Void in
                print(error.description)
        }
    }
    
    class func updateFirebaseEmployee(status: String, inRange: Bool) {
        
        let ref = Firebase(url: nickelEmployees)
        
        if let name = User.sharedInstance.name {
            ref.childByAppendingPath(name).setValue(["name": name, "status": status, "inRange": inRange])
        }
    }
    
    class func listenForEmployeeUpdates(completionHandler: (employees: [EmployeeObj]) -> Void) {
        let ref = Firebase(url: nickelEmployees)
        ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            var employees = [EmployeeObj]()
            
            for employee in snapshot.children.allObjects as! [FDataSnapshot] {
                if let map = employee.value as? [String: AnyObject] {
                    if map["inRange"] == nil {
                    employees.append(EmployeeObj(name: map["name"] as! String, status: map["status"] as! String, inRange: true))

                    } else {
                    employees.append(EmployeeObj(name: map["name"] as! String, status: map["status"] as! String, inRange: map["inRange"] as! Bool))
}
                }
            }
            
            completionHandler(employees: employees)
            
            }) { (error) -> Void in
                print(error.description)
        }
    }
    
}
