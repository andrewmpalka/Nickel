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
    func businessHelper(name: UITextField, email: UITextField, location: CLLocation) {
        
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
                print("Organization to iCloud: \(newBiz)")
            }
        }
    }
    func publicUserHelper(name: String) {
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let newPublicUserData = CKRecord(recordType: "Users")
        
//        newPublicUserData.set
    }
    func privateUserHelper() {
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        let newPrivateUserData = CKRecord(recordType: "Users")
    }
}