//
//  User.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import CloudKit

class User: NSObject {
    
    var userRecordID: CKRecordID
    var firstName: String?
    var lastName: String?
    var name: String?
    var nickname: String?
    
    
    init(userRecordID: CKRecordID) {
        self.userRecordID = userRecordID
    }
    
}
