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
    func newBusinessHelper(name: UITextField, email: UITextField, location: CLLocation){
        
        let newBusiness = CKRecord(recordType: "Businesses")
        
        //        CURRENT_BUSINESS_RECORD_NAME = newBusiness.recordID.recordName
        //        CURRENT_BUSINESS_RECORD_ID = newBusiness.recordID
        
        newBusiness.setObject(name.text, forKey: "Name")
        newBusiness.setObject(email.text, forKey: "Email")
        newBusiness.setObject(location, forKey: "Location")
        //    setUID(newOrg, admin: newAdmin)
        
        publicDatabase.saveRecord(newBusiness) { (newBiz, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("Business beamed to iCloud: \(newBiz)")
                Business.sharedInstance = newBusiness
            }
        }
    }
    //ONLY CALL THIS WHEN NEW BUSINESS IS BEING MADE OTHERWISE THERE WILL BE ERRORS
    func newEmployeeHelperForBusiness(var bizRec: CKRecord) {
        
    
        
        let fetchRecordsOperation = CKFetchRecordsOperation(recordIDs: [bizRec.recordID])
        

                
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
        let arrayOfReferences = getArrayOfEmployeeReferences(string)

        

        fetchBizAndSave(bizRec, index: 6, editedData: arrayOfReferences)
        
        newEmployee.setObject(User.sharedInstance.name, forKey: "Name")
        newEmployee.setObject(bizRef, forKey: "UIDBusiness")
        //        newEmployee.setObject(bizRec.recordID.recordName, forKey: "UIDBusiness")
        
        publicDatabase.saveRecord(newEmployee) { (newUser, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("Employee beamed to iCloud: \(newUser!)")
                newEmployee.recordID.recordName
            }
        }
    }
    
    
    func editBusinessDataHelper(editedBusiness: CKRecord, index: Int, var editedData: CKRecordValue) {
        
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
            editedData = editedData as! [CKReference]
            print("EDITED DATA \(editedData)")
            
        default :
            print("shrug")
        }
        
        editedBusiness.setObject(editedData, forKey: key)
        
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
    
    func getArrayOfEmployeeReferences(string: String) -> [CKReference] {
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
        }
        return arrayOfRecords
    }
    
    func fetchBizAndSave(var bizRec: CKRecord, index: Int, editedData: CKRecordValue) {
        
        publicDatabase.fetchRecordWithID(bizRec.recordID) { record, error in
            if error != nil {
                print(error)
            } else {
                print("Business grabbed from iCloud: \(record!)")
                bizRec = record!
                //            bizRef = CKReference(recordID: bizRec.recordID, action: CKReferenceAction.DeleteSelf)
                print("Business IS \(bizRec.recordID.recordName)")
                self.editBusinessDataHelper(bizRec, index: index, editedData: editedData)

            }
        }
        
        
    }
    
    
}