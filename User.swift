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
    
    static let sharedInstance = User(userRecordID: CKRecordID(recordName: userDefaults.valueForKey("userRecordID") as! String))

    var userRecordID: CKRecordID
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
    
    
}

//let userSingletonGlobal = User(userRecordID: CKRecordID(recordName: userDefaults.valueForKey("userRecordID") as! String))
