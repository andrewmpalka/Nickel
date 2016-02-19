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
    func newBusinessHelper(name: UITextField, email: UITextField, location: CLLocation) {
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let newBusiness = CKRecord(recordType: "Businesses")
        
        newBusiness.setObject(name.text, forKey: "Name")
        newBusiness.setObject(email.text, forKey: "Email")
        newBusiness.setObject(location, forKey: "Location")
        
        //    setUID(newOrg, admin: newAdmin)
        
        publicDatabase.saveRecord(newBusiness) { (newBiz, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("Business beamed to iCloud: \(newBiz)")
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