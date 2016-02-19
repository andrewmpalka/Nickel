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


extension UIViewController {
    func newBusinessHelper(name: UITextField, email: UITextField, location: CLLocation){
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let newBusiness = CKRecord(recordType: "Businesses")
        
        CURRENT_BUSINESS_RECORD_NAME = newBusiness.recordID.recordName
        CURRENT_BUSINESS_RECORD_ID = newBusiness.recordID
        
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
    
    func editBusinessDataHelper(recordID: CKRecordID, index: Int, editedData: AnyObject) {
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
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
    func newPublicUserHelper(name: String) {
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let newPublicUserData = CKRecord(recordType: "Users")
        
        newPublicUserData.setObject(name,
            forKey: "Name")
        
        publicDatabase.saveRecord(newPublicUserData) { newPublicUserData, error in
            if error != nil {
                print(error)
            } else {
                print("Public User Data beamed to iCloud \(newPublicUserData)")
            }
        }
        
        //        newPublicUserData.set
    }
    func newPrivateUserHelper() {
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        let newPrivateUserData = CKRecord(recordType: "Users")
    }
}