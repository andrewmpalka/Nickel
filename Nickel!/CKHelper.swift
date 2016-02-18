//
//  CKHelper.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/18/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitHelper {
    var cloudKitHelper: CloudKitHelper?
    var container: CKContainer
    var publicDB: CKDatabase
    let privateDB: CKDatabase
    
    init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
    }
    
    func saveRecord(todo: NSString) {
        let  toDoRecord = CKRecord(recordType: "Todos")
        toDoRecord.setValue(todo, forKey: "toDoText")
        publicDB.saveRecord(toDoRecord) { (record, error) -> Void in
            print("Saved to cloud")
        }
    }
    
}
