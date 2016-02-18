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
    func businessHelper(name: UITextField, email: UITextField) {
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let newBusiness = CKRecord(recordType: "Businesses")
        
        newBusiness.setObject(name.text, forKey: "name")
        newBusiness.setObject(email.text, forKey: "email")
        
        //    setUID(newOrg, admin: newAdmin)
        
        publicDatabase.saveRecord(newBusiness) { (newBiz, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("Organization to iCloud: \(newBiz)")
            }
        }
    }
}