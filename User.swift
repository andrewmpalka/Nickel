//
//  User.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import CloudKit

class User {
    
//      static let sharedInstance = User(userRecordID: (CKRecordID(recordName: "_7e72291a13bb1603ee4666e67b6d269d")))
    
        static let sharedInstance = User.userSingleton()

    weak var userRecordID: CKRecordID?
    var firstName: String?
    var lastName: String?
    var name = String?()
    var nickname: String?
    var positionTitle: String?
    var emailAddress: String?
    var profilePic: UIImage?
    var message: [String]?

    init(userRecordID: CKRecordID) {
        self.userRecordID = userRecordID
    }
    
    func setFullName() {
        self.name = "\(self.firstName!) \(self.lastName!)"
        User.sharedInstance.name = self.name
    }
    
    private class func userSingleton() -> User {
        if let ud = userDefaults.valueForKey("userRecordID") as? String {
            return User(userRecordID: CKRecordID(recordName: ud))
        } else {
            return User(userRecordID: (CKRecordID(recordName: "_7e72291a13bb1603ee4666e67b6d269d")))
        }
    }
    
    
}

//let userSingletonGlobal = User(userRecordID: CKRecordID(recordName: userDefaults.valueForKey("userRecordID") as! String))
