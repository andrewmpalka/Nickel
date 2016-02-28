//
//  Employee.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/25/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

class Employee: CKRecord {
    static var sharedInstance = CKRecord(recordType: "Employees")

    
    var firstName: String?
    var lastName: String?
    
    var name: String?
    var nickname: String?
    
    
    var matchIndicatorBoolAsInt: Int?
    var permissionLevelBoolAsInt: Int?
    
    var timestamp: NSDate?
    
    var profilePicAsNSData: NSData?
    
    var UIDBussines: CKReference?
    var UIDMessage: [CKReference]?
    
    func makeEmployeeFromUser(user: User) {
        let recordID = CKRecordID(recordName: (user.userRecordID?.recordName)!)
//        let record = CKRecord(recordType: "Users", recordID: recordID)
        let reference = CKReference(recordID: recordID, action: .DeleteSelf)
        
        Employee.sharedInstance.setValue(reference, forKey: "EmployeeToUserLinker")
        
        
        self.name = user.name
        self.nickname = user.nickname
        
    }
}
