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
    
    static let sharedInstace = DataServices()
    
    
    
    class func checkInRange() {
        
    }
    // method for timeStamp
    class func generateTimestamp() -> String {
        let time = NSDate(timeIntervalSinceNow: NSTimeInterval())
        
        print(time.description)
        print("NOT THE PROBLEM")
        
        
        return  NSDateFormatter.localizedStringFromDate(time, dateStyle: .ShortStyle, timeStyle: .MediumStyle)
    }
    
    //    static let geofireRef = Firebase(url: stdRef + "business/location")
    //    static let geoFire = GeoFire(firebaseRef: geofireRef)
    
    static var mintBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 43936, minor: 10638, identifier: "mint")
    
    static var roomSize: Int = 0
    
    static let stdRef = "https://nickelapp.firebaseio.com/"
    
    static var nickelZone = "https://nickelapp.firebaseio.com/zone/SHRUG"
    
    static let nickelUser = "https://nickelapp.firebaseio.com/user"
    
    static let nickelBusiness = "https://nickelapp.firebaseio.com/business/"
    static var nickelBiz = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/"
    static var nickelLog = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/log"
    static var nickelOccupants = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/occupants/"
    static var nickelEmployees = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/occupants/employees"
    static var nickelGuests = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/occupants/guests"
    static let nickelBeams = "https://nickelapp.firebaseio.com/business/\(BusinessObj.sharedInstance.id!)/occupants/employees/\(UserObj.sharedInstance.id!)/beams"
    static let nickelGroupBeam = "https://nickelapp.firebaseio.com/business/employees/beams/groupBeam"
    static let nickelPrivateBeam = "https://nickelapp.firebaseio.com/business/employees/beams/privateBeam"
    
    static let geofireRef = Firebase(url: stdRef + "locations")
    static let geoFire = GeoFire(firebaseRef: geofireRef)
//
    private var _REF_USER = Firebase(url: nickelUser)
    
    var REF_USER: Firebase {
        return _REF_USER
    }
    
    private var _REF_BUSINESS = Firebase(url: nickelBiz)
    
    var REF_BUSINESS: Firebase {
        _REF_BUSINESS.keepSynced(true)
        return _REF_BUSINESS
    }
    
//
    class func sendPrivateMessage(toUser: String, message: String) {
        let ref = Firebase(url: nickelPrivateBeam)
        if let name = User.sharedInstance.name {
            ref.childByAutoId().setValue(["from": name, "to": toUser, "message": message])
            
        }
    }
    
    class func stamp(event: String) {
        let tStamp = DataServices.generateTimestamp()
        let logEntry = event + " " + tStamp
        
        
        let ref = Firebase(url: nickelLog)
        ref.childByAutoId().setValue(["event": logEntry])
        
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
//
    //
        //
            //
                //
                    //
                        //
    class func listenForActivityLog(completionHandler: (log: [String]) -> Void)  {
      let lref = Firebase(url: nickelLog)
        var log = [String]()
        
        print(lref)
        
        lref.observeEventType(FEventType.Value, withBlock: { snapshot in
            for n in snapshot.children.allObjects as! [FDataSnapshot] {
                
                print(n)
                if let map = n.value as? [String: AnyObject] {
                    
                    for key in map {
                        let msg = key.1 as! String
                        log.insert(msg, atIndex: 0)
                        
                    }
                }
                
            }
            print(log)
            completionHandler(log: log)
            
        }) { (error) -> Void in
            print(error.description)
        }
    }
    
    class func occupantSignedOut() {
        
        let eref = Firebase(url: "\(nickelEmployees + "/" + UserObj.sharedInstance.id!)")
        let gref = Firebase(url: "\(nickelGuests + "/" + UserObj.sharedInstance.id!)")
        
        var int = 0
        repeat {
            print("HITTIN")
            print(UserObj.sharedInstance.id)
            print(eref)
            int += 1
        } while int < 10
        
        DataServices.stamp("\(UserObj.sharedInstance.name) has signed out")
        
        if UserObj.sharedInstance.id?.characters.count > 8 {
            gref.removeValue()
        } else {
            eref.removeValue()
        }
        
    }
    
    class func updateFirebaseEmployee(status: String, inRange: Bool) {
        
        if status == "in" {
            DataServices.stamp("\(UserObj.sharedInstance.name) has entered!")
        } else {
            print("User: \(UserObj.sharedInstance.name)")
            DataServices.stamp("\(UserObj.sharedInstance.name) has left the building!")
        }
        
        let ref = Firebase(url: nickelEmployees)
        
        if let name = UserObj.sharedInstance.id {
            ref.childByAppendingPath(name).setValue(["name": UserObj.sharedInstance.name, "status": status, "inRange": inRange])
        }
    }
    
    class func addGuest() -> Bool {
        
        
        if (ERROR_LOG == false) {
            print("LOGGING")
            print(ERROR_LOG)
            let uref = Firebase(url: nickelUser)
            
            let eref = Firebase(url: nickelEmployees)
            let ref = Firebase(url: nickelGuests)
            
            
            
            if (UserObj.sharedInstance.name == "Anonymous") {
                let anonProfilePic = "NULL"
                
                var anonStatus = "out"
                if (IN_RANGE == "in") {
                anonStatus = "in"
                }
                
                
                let str = UserObj.sharedInstance.id!
                let anonAlias = UserObj.sharedInstance.id!.substringWithRange(Range<String.Index>(start: str.startIndex.advancedBy(2), end: str.endIndex.advancedBy(-23)))
                ref.childByAppendingPath(UserObj.sharedInstance.id).setValue(["id": UserObj.sharedInstance.id!,"name": UserObj.sharedInstance.name, "device": UserObj.sharedInstance.device, "alias": anonAlias, "cachedData": "null", "status": anonStatus, "profilePic": anonProfilePic])
                
                
            } else {
                UserObj.sharedInstance.device = "github"
                print(UserObj.sharedInstance.id)
                print(UserObj.sharedInstance.name)
                print(UserObj.sharedInstance.alias)
                
                
                var userStatus = "out"
                if (IN_RANGE == "in") {
                    userStatus = "in"
                }
                
                var int = 0
                
                repeat { print("\(UserObj.sharedInstance.profilepictureURLString!)"); int += 1 } while int < 10
                
                
            eref.childByAppendingPath(UserObj.sharedInstance.id).setValue(["name": UserObj.sharedInstance.name, "device": UserObj.sharedInstance.device, "alias": UserObj.sharedInstance.alias!, "cachedData": UserObj.sharedInstance.cachedData!, "status": userStatus, "id": UserObj.sharedInstance.id!, "profilePic": "\(UserObj.sharedInstance.profilepictureURLString!)"])
            
            uref.childByAppendingPath(UserObj.sharedInstance.id).setValue(["name": UserObj.sharedInstance.name, "device": UserObj.sharedInstance.device, "alias": UserObj.sharedInstance.alias!, "cachedData": UserObj.sharedInstance.cachedData!])
            }
            DataServices.stamp("\(UserObj.sharedInstance.name) has signed in")
            return true
        } else {
            print("LOG IS READING AN ERROR")
            return false
        }
        }

        
        class func listenForEmployeeUpdates(completionHandler: (employees: [EmployeeObj]) -> Void) {
            let ref = Firebase(url: nickelEmployees)
            
            if BusinessObj.sharedInstance.name == nil || BusinessObj.sharedInstance.name == "NULL" {
                BusinessObj.sharedInstance.id = BUSINESS_ID
            }
            
            DataServices.checkInRange()
            
            ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
                var employees = [EmployeeObj]()
                
                for employee in snapshot.children.allObjects as! [FDataSnapshot] {
                    if let map = employee.value as? [String: AnyObject] {
                        if map["inRange"] == nil {
                            employees.append(EmployeeObj(id: map["id"] as! String, name: map["name"] as! String, status: map["status"] as! String, profilePic: map["profilePic"] as! String, inRange: true, alias: map["alias"] as! String))
                            
                        } else {
                            employees.append(EmployeeObj(id: map["id"] as! String, name: map["name"] as! String, status: map["status"] as! String, profilePic: map["profilePic"] as! String, inRange: map["inRange"] as! Bool,alias: map["alias"] as! String))
                        }
                    }
                }
                
                completionHandler(employees: employees)
                
            }) { (error) -> Void in
                print(error.description)
            }
        }
    class func listenForGuestUpdates(completionHandler: (guests: [GuestObj]) -> Void) {
        let ref = Firebase(url: nickelGuests)
        ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            var guests = [GuestObj]()
            
            for guest in snapshot.children.allObjects as! [FDataSnapshot] {
                if let map = guest.value as? [String: AnyObject] {
                    if map["inRange"] == nil {
                        guests.append(GuestObj(id: map["id"] as! String, name: map["name"] as! String, status: map["status"] as! String, profilePic: map["profilePic"] as! String, inRange: true, alias: map["alias"] as! String))
                        
                    } else {
                        guests.append(GuestObj(id: map["id"] as! String, name: map["name"] as! String, status: map["status"] as! String, profilePic: map["profilePic"] as! String, inRange: map["inRange"] as! Bool,alias: map["alias"] as! String))
                    }
                }
            }
            
            completionHandler(guests: guests)
            
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
            let fref = Firebase(url: stdRef + "locations")
            let gfref = GeoFire(firebaseRef: fref)
            
            //        var business = BusinessObj(id: "NULL", name: "NULL", profilePic: "NULL", location: CLLocation())
            
            ref.childByAppendingPath(business.id).setValue(["name": business.name!, "profilePic": business.profilePic!, "city" : business.city!])
            gFire.setLocation(business.location, forKey: "location") { (error) in
                if (error != nil) {
                    print("An error occured: \(error)")
                } else {
                    print("Saved location successfully!")
                    
                    gfref.setLocation(business.location, forKey: "\(business.id!)") { (error) in
                        if (error != nil) {
                            print("An error occured: \(error)")
                        } else {
                            print("Saved location successfully!")
                            
                        }
                    }
                }
            }


            
            
        }
    
    func isThisYourCard() {
    
        
    }
        
        
}
