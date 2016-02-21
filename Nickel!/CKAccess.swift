//
//  CKAccessHelper.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/18/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitAccess {
    var container: CKContainer
    var privateDatabase: CKDatabase
    var publicDatabase: CKDatabase
    
    init() {
        container = CKContainer.defaultContainer()
        privateDatabase = container.privateCloudDatabase
        publicDatabase = container.publicCloudDatabase
}
    func newRecord() {
        let timestamp = String(NSDate.timeIntervalSinceReferenceDate())
        let timestampParts = timestamp.componentsSeparatedByString(".")
        let UID = timestampParts[0]
        
        let record = CKRecord(recordType: "Users")
        record.setObject(UID, forKey: "UID")
        
        publicDatabase.saveRecord(record) { (record, error) -> Void in
            if error != nil {
                print(error)
            }
        }
    }
}

