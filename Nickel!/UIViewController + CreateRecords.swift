//
//  UIViewController + CreateBusiness.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/18/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


extension SuperViewController {
    func newBusinessHelper(name: UITextField, email: UITextField, location: CLLocation){
    
        let newBusiness = CKRecord(recordType: "Businesses")
        
//        CURRENT_BUSINESS_RECORD_NAME = newBusiness.recordID.recordName
//        CURRENT_BUSINESS_RECORD_ID = newBusiness.recordID
        
        newBusiness.setObject(name.text, forKey: "Name")
        newBusiness.setObject(email.text, forKey: "Email")
        newBusiness.setObject(location, forKey: "Location")
        //    setUID(newOrg, admin: newAdmin)
        
        publicDatabase.saveRecord(newBusiness) { (newBiz, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("Business beamed to iCloud: \(newBiz)")
                newBusiness.recordID.recordName
            }
        } 
    }
    func newEmployeeHelper() {
    let newEmployee = CKRecord(recordType: "Employees")
        newEmployee.setObject(User.sharedInstance.name, forKey: "Name")
        
        publicDatabase.saveRecord(newEmployee) { (newUser, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("Business beamed to iCloud: \(newUser)")
                newEmployee.recordID.recordName
            }
        }
        
    }

    
    func editBusinessDataHelper(recordID: CKRecordID, index: Int, editedData: AnyObject) {
        
        let editedBusiness = CKRecord(recordType: "Businesses", recordID: recordID)
        
        var key = String()
        switch index {
        case 1:
            key = "Name"
        case 2:
            key = "Email"
        case 3:
            key = "Location"
        case 4:
            key = "Employees"
        case 5:
            key = "Beacons"
        default :
            print("shrug")
        }
        
        editedBusiness.setObject(editedData as? CKRecordValue, forKey: key)
        
        publicDatabase.saveRecord(editedBusiness) { editedBusiness, error in
            if error != nil {
                print(error)
            } else {
                print("Business beamed to iCloud: \(editedBusiness)")
            }
        }

    }
    
    
}