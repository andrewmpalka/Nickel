//
//  DataServices.swift
//  Nickel!
//
//  Created by Jonathan Kilgore on 3/2/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import Firebase
import GeoFire
import CoreLocation
import OAuthSwift

class DataServices {
    
    // method for timeStamp
    class func generateTimestamp() -> String {
        let time = NSDate(timeIntervalSinceNow: NSTimeInterval())
        
        print(time.description)
        print("NOT THE PROBLEM")
        
        
        
        return  NSDateFormatter.localizedStringFromDate(time, dateStyle: .ShortStyle, timeStyle: .MediumStyle)
    }
    
    //    static let geofireRef = Firebase(url: stdRef + "business/location")
    //    static let geoFire = GeoFire(firebaseRef: geofireRef)
    
    static let stdRef = "https://nickelapp.firebaseio.com/"
    
    static var nickelZone = "https://nickelapp.firebaseio.com/zone/SHRUG"
    
    static let nickelUser = "https://nickelapp.firebaseio.com/user"
    
    static let nickelBusiness = "https://nickelapp.firebaseio.com/business"
    static var nickelLog = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/"
    static var nickelOccupants = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/occupants"
    static var nickelEmployees = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/occupants/employees"
    static var nickelGuests = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/occupants/guests"
    static let nickelBeams = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/occupants/employees/\(UserObj.sharedInstance.id!)/beams"
    static let nickelGroupBeam = "https://nickelapp.firebaseio.com/business/employees/beams/groupBeam"
    static let nickelPrivateBeam = "https://nickelapp.firebaseio.com/business/employees/beams/privateBeam"
    
    static let geofireRef = Firebase(url: nickelBusiness)
    static let geoFire = GeoFire(firebaseRef: geofireRef)

    
    class func sendPrivateMessage(toUser: String, message: String) {
        let ref = Firebase(url: nickelPrivateBeam)
        if let name = User.sharedInstance.name {
            ref.childByAutoId().setValue(["from": name, "to": toUser, "message": message])
            
        }
    }
    
    class func stamp(event: String) {
        let tStamp = DataServices.generateTimestamp()
        let ref = Firebase(url: nickelLog)
        ref.childByAppendingPath("log").setValue([event: tStamp])
        
    }
    
    class func listenForPrivateMessages(completionHandler: (messages: [MessageObj]) -> Void) {
        let ref = Firebase(url: nickelPrivateBeam)
        
        
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
        let ref = Firebase(url: nickelGroupBeam)
        if let name = User.sharedInstance.name {
            ref.childByAutoId().setValue(["from": name, "message": message])
        }
    }
    
    class func listenForGroupMessages(completionHandler: (messages: [MessageObj]) -> Void)  {
        let ref = Firebase(url: nickelGroupBeam)
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
    
    class func addUser() {
        let ref = Firebase(url: nickelUser)
        
    }
    
    
    class func addGuest() {
        
        
        if (ERROR_LOG == false) {
            print("LOGGING")
            print(ERROR_LOG)
            let uref = Firebase(url: nickelUser)
            let ref = Firebase(url: nickelGuests)
            if (UserObj.sharedInstance.name == "Anonymous") {
                ref.childByAppendingPath(UserObj.sharedInstance.id).setValue(["name": UserObj.sharedInstance.name!, "device": UserObj.sharedInstance.device!, "alias": "Guest"])
            } else {
                UserObj.sharedInstance.device = "github"
                print(UserObj.sharedInstance.id)
                print(UserObj.sharedInstance.name)
                print(UserObj.sharedInstance.alias)
            
            
            uref.childByAppendingPath(UserObj.sharedInstance.id).setValue(["name": UserObj.sharedInstance.name!, "device": UserObj.sharedInstance.device!, "alias": UserObj.sharedInstance.alias!, "cachedData": UserObj.sharedInstance.cachedData!])
            }
            DataServices.stamp("\(UserObj.sharedInstance.name) has entered")
        } else {
            print("LOG IS READING AN ERROR")
        }
        }
        
        
        class func listenForEmployeeUpdates(completionHandler: (employees: [EmployeeObj]) -> Void) {
            let ref = Firebase(url: nickelEmployees)
            ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
                var employees = [EmployeeObj]()
                
                for employee in snapshot.children.allObjects as! [FDataSnapshot] {
                    if let map = employee.value as? [String: AnyObject] {
                        if map["inRange"] == nil {
                            employees.append(EmployeeObj(id: map["id"] as! String, name: map["name"] as! String, status: map["status"] as! String, profilePic: map["profilePic"] as! String, inRange: true))
                            
                        } else {
                            employees.append(EmployeeObj(id: map["id"] as! String, name: map["name"] as! String, status: map["status"] as! String, profilePic: map["profilePic"] as! String, inRange: map["inRange"] as! Bool))
                        }
                    }
                }
                
                completionHandler(employees: employees)
                
            }) { (error) -> Void in
                print(error.description)
            }
        }
        
        class func locationSet(location: CLLocation, city: String) {
            
            let gref = Firebase(url: "")
            let gFire = GeoFire(firebaseRef: gref)
            
            
            let state: String = generateStateWithLength(20) as String
            let uniqueKey: String = city + "@@" + state
            
            gFire.setLocation(location, forKey:uniqueKey) { (error) in
                if (error != nil) {
                    print("An error occured: \(error)")
                } else {
                    print("Saved location successfully!")
                }
            }
        }

        
        class func businessSet(business: BusinessObj) {
            print("Passed to DataServices")
            let ref = Firebase(url: nickelBusiness)
            let gref = Firebase(url: nickelBusiness + "/\(business.id!)/")
            let gFire = GeoFire(firebaseRef: gref)
            
            //        var business = BusinessObj(id: "NULL", name: "NULL", profilePic: "NULL", location: CLLocation())
            
            ref.childByAppendingPath(business.id).setValue(["name": business.name!, "profilePic": business.profilePic!, "city" : business.city!])
            gFire.setLocation(business.location, forKey: "location") { (error) in
                if (error != nil) {
                    print("An error occured: \(error)")
                } else {
                    print("Saved location successfully!")
                }
            }
            
            
        }
    
    func isThisYourCard() {
    
        
    }
        
        
}
