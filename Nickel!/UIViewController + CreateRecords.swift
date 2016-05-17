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


extension SuperViewController {
    func newBusinessHelper(){
        print("Add Business Initiated")
        DataServices.businessSet(BusinessObj.sharedInstance)
        /*
        let newBusiness = CKRecord(recordType: "Businesses")
        
        newBusiness.setObject(name.text, forKey: "Name")
        newBusiness.setObject(email.text, forKey: "Email")
        newBusiness.setObject(location, forKey: "Location")

        
    
        
        publicDatabase.saveRecord(newBusiness) { (newBiz, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("Business beamed to iCloud: \(newBiz)")
                Business.sharedInstance = newBusiness
                
            }
        }
     */
    }
    //ONLY CALL THIS WHEN NEW BUSINESS IS BEING MADE OTHERWISE THERE WILL BE ERRORS
    func newEmployeeHelperForBusiness(let bizRec: CKRecord) {
        
        //        var array = [String]()
        //
        //        var arrayOfRecords = [CKReference]()
        //
        //        array = defaultEmployeeRecordsForBusinessArray as! Array
        //
        //        if array.count > 0 {
        //            array.insert(string, atIndex: array.count - 1)
        //
        //            for object in array {
        //                let recordID = CKRecordID(recordName: object as String)
        //                let reference = CKReference(recordID: recordID, action: CKReferenceAction.DeleteSelf)
        //                arrayOfRecords.append(reference)
        //            }
        //        }
        
        let bizRef = CKReference(recordID: Business.sharedInstance.recordID, action: .DeleteSelf)
        let newEmployee = CKRecord(recordType: "Employees")
        let employeeRef = CKReference(recordID: newEmployee.recordID, action: .DeleteSelf)
        
        let string = employeeRef.recordID.recordName
        
        let arrayOfReferences = getArrayOfEmployeeReferences(string, ref: employeeRef)
        
        let biz = bizRec
        
        fetchBizAndSave(biz, index: 6, editedData: arrayOfReferences)
        
        newEmployee.setObject(User.sharedInstance.name, forKey: "Name")
        newEmployee.setObject("@\(User.sharedInstance.name!)", forKey: "Nickname")
        newEmployee.setObject(1, forKey: "InsideField")
        newEmployee.setObject(bizRef, forKey: "UIDBusiness")
//                newEmployee.setObject(bizRec.recordID.recordName, forKey: "UIDBusiness")
        
        publicDatabase.saveRecord(newEmployee) { (newUser, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("Employee beamed to iCloud: \(newUser!)")
                newEmployee.recordID.recordName
            }
        }
    }
    
    
    func editBusinessDataHelper(editedBusiness: CKRecord, index: Int, editedData: CKRecordValue) {
        
        print("EDITED BIZ \n\n\n sss\(editedBusiness)")
        
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
            
        case 6:
            key = "UIDEmployees"
            //            editedData = editedData as! [CKReference]
            print("EDITED DATA \(editedData)")
            
        default :
            print("shrug")
        }
        
        Business.sharedInstance.setObject(editedData, forKey: key)
        
        var array = [CKRecord]()
        array.append(editedBusiness)
        
        let modifyOperation: CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: array, recordIDsToDelete: nil)
        modifyOperation.savePolicy = .IfServerRecordUnchanged
        modifyOperation.modifyRecordsCompletionBlock = {savedRecords, deletedRecordsIDs, errors in
            if errors != nil {
                print("Error saving records: \(errors!.localizedDescription)")
            } else {
                print("Successfully updated all the records")
            }
        }
        
        
        publicDatabase.addOperation(modifyOperation)
        print("Business successfully edited and beamed to the cloud")
        //        publicDatabase.saveRecord(editedBusiness) { editedBusiness, error in
        //            if error != nil {
        //                print(error)
        //            } else {
        //                print("Business beamed to iCloud: \(editedBusiness)")
        //            }
        //        }
        
    }
    
    func getArrayOfEmployeeReferences(string: String, ref: CKReference) -> [CKReference] {
        var array = [String]()
        
        var arrayOfRecords = [CKReference]()
        if defaultEmployeeRecordsForBusinessArray != nil {
            array = defaultEmployeeRecordsForBusinessArray as! Array
        }
        if array.count > 0 {
            array.insert(string, atIndex: array.count - 1)
            
            for object in array {
                let recordID = CKRecordID(recordName: object as String)
                let reference = CKReference(recordID: recordID, action: CKReferenceAction.DeleteSelf)
                arrayOfRecords.append(reference)
                
            }
                self.createArrayOfRecordNamesFromArrayOfReferencesAndThenSaveThatToUserDefaults(arrayOfRecords)
//            userDefaults.setValue(arrayOfRecords, forKey: "currentEmployeeRecordsArray")
            
        } else {
            arrayOfRecords.append(ref)
            let recordName = ref
            let initialAddToArrayOfRecords: Array = [recordName]
//            userDefaults.setValue(initialAddToArrayOfRecords, forKey: "currentEmployeeRecordsArray")
            self.createArrayOfRecordNamesFromArrayOfReferencesAndThenSaveThatToUserDefaults(initialAddToArrayOfRecords)
            
        }
        print("A/nR/nR/nA/nY")
        print(arrayOfRecords)
        Business.sharedInstance.setObject(arrayOfRecords, forKey: "UIDEmployees")
        return arrayOfRecords
    }
    
    func fetchBisuness(bizRec: CKRecord) {
    
    let fetchOp = CKFetchRecordsOperation(recordIDs: [bizRec.recordID])
        fetchOp.fetchRecordsCompletionBlock = {fetchedRecords, errors in
            if errors != nil {
                print("Error fetching records: \(errors!.localizedDescription)")
            } else {
                print("Successfully fetched all the records")
                let record = fetchedRecords![bizRec.recordID]!

                
                userDefaults.setValue(record.recordID.recordName, forKey: "BusinessRecordIDName")
            }
            
    }
        publicDatabase.addOperation(fetchOp)
    }
    
    func fetchBizAndSave( bizRec: CKRecord, index: Int, editedData: CKRecordValue) {
        
        let fetchOp = CKFetchRecordsOperation(recordIDs: [bizRec.recordID])
        fetchOp.fetchRecordsCompletionBlock = {fetchedRecords, errors in
            if errors != nil {
                print("Error fetching records: \(errors!.localizedDescription)")
            } else {
                print("Successfully fetched all the records")
                
                
                var array = [CKRecord]()
                let fetchedRecordAsDict: [CKRecordID: CKRecord] = fetchedRecords! as [CKRecordID: CKRecord]
                let fetchedRecord = fetchedRecordAsDict[Business.sharedInstance.recordID]
                
                //needs to be changed eventually
                let object = Business.sharedInstance.objectForKey("UIDEmployees")
                let key = "UIDEmployees"
                
                //This is okay
                fetchedRecord?.setObject(object, forKey: key)
                print(fetchedRecord!)
                array.append(fetchedRecord!)
                
                let modifyOperation: CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: array, recordIDsToDelete: nil)
                modifyOperation.savePolicy = .IfServerRecordUnchanged
                modifyOperation.modifyRecordsCompletionBlock = {savedRecords, deletedRecordsIDs, errors in
                    if errors != nil {
                        print("Error saving records: \(errors!.localizedDescription)")
                    } else {
                        print("Successfully updated all the records")
                    }
                }
                publicDatabase.addOperation(modifyOperation)
            }
        }
        publicDatabase.addOperation(fetchOp)
    }
    
    func createArrayOfRecordNamesFromArrayOfReferencesAndThenSaveThatToUserDefaults(array: [CKReference]) {
        var stringArray:[String]?
        for record in array {
        
        let string = record.recordID.recordName
            
        stringArray?.append(string)
        }
        
        
        userDefaults.setValue(stringArray, forKey: "currentEmployeeRecordsArray")
        
    }
    
    func addMessageToBusinessMessageList(bizRec: CKRecord, employeeRec: CKRecord, messageRec: CKRecord, message: String) {
        
        if bizRec.objectForKey("UIDMessages") != nil {
            
            var array = [String]()
            if userDefaults.objectForKey("currentMessageRecordsForBusinessArray") != nil {
                array = userDefaults.objectForKey("currentMessageRecordsForBusinessArray") as! Array
            }
            array.append(message)
            userDefaults.setValue(array, forKey: "currentMessageRecordsForBusinessArray")
            
            messageRec.setValue(array, forKey: "PublicMessages")
            
            let recordsToSave: [CKRecord] = [messageRec]
            
            let op:CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: nil)
            
            op.savePolicy = .IfServerRecordUnchanged
            op.modifyRecordsCompletionBlock = {savedRecords, deletedRecordsIDs, errors in
                if errors != nil {
                    print("Error saving records: \(errors!.localizedDescription)")
                } else {
                    print("Successfully updated all the records")
                }
            }
            publicDatabase.addOperation(op)
        } else {
            bizRec.setValue([message], forKey: "UIDMessages")
            
            userDefaults.setValue([message], forKey: "currentMessageRecordsForBusinessArray")
            
            messageRec.setValue([message], forKey: "PublicMessages")
            
            let recordsToSave: [CKRecord] = [messageRec]
            
            let op:CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: nil)
            
            op.savePolicy = .IfServerRecordUnchanged
            op.modifyRecordsCompletionBlock = {savedRecords, deletedRecordsIDs, errors in
                if errors != nil {
                    print("Error saving records: \(errors!.localizedDescription)")
                } else {
                    print("Successfully updated all the records")
                }
            }
            publicDatabase.addOperation(op)

        }
    }
    
    func getOneRecordOfType(recordType: String, reference: CKReference) {
        var record = CKRecord(recordType: recordType)
        print("REFERENCE RECORD")
        print(reference.recordID.recordName)
        
        
        let fOp = CKFetchRecordsOperation(recordIDs: [reference.recordID])
        fOp.fetchRecordsCompletionBlock = {fetchedRecords, errors in
            if errors != nil {
                print("Error fetching records: \(errors!.localizedDescription)")
            } else {
                print("Successfully found the begotten record")
                record = fetchedRecords![reference.recordID]! as CKRecord
                
                print("BEGOTTEN RECORD")
                self.begottenRecord = record
                print(self.begottenRecord?.recordID.recordName)
            }
        }
        publicDatabase.addOperation(fOp)
        
    }
    
    func getRecordsofType(recordType: String, references: [CKReference]) -> [CKRecord]{
        self.recordsFromReference(references)
        
        return [CKRecord(recordType: recordType)]
    }
    
    func oneRecordFromReference(reference: CKReference) {
        
    }
    func recordsFromReference(references: [CKReference]) {
        
    }
}