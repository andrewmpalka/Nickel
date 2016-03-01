//
//  Messages.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/29/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

class Messages: CKRecord {
    
    static var sharedInstance = CKRecord(recordType: "Messages")
    
    var privateMessages: [String]?
    var publicMessages: [String]?
    
    var ContainsMessages: [CKReference]?
}
