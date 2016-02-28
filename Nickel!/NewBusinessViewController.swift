//
//  NewBusinessViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

class NewBusinessViewController: SuperViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var businessNameTextField: UITextField!
    
    @IBOutlet weak var businessEmailTextField: UITextField!
    
    let placePlacerholder = CLLocation()
    let coreLocationManager = CLLocationManager()
    let appDelegate = AppDelegate()
    
    var UID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Nickel"

        self.businessEmailTextField.delegate = self
        self.businessNameTextField.delegate = self
        coreLocationManager.delegate = self
    }
//MARK UITextField Functions
    
    func textFieldChecker(textField: UITextField, indicator: Int) -> Bool {
        
        if(textField.text?.isEmpty == false) {
            if(validateFieldInput(textField.text!, identifier: indicator) == true) {
                return true
            }
            else {
                textField.textColor = .redColor()
                if textField == businessNameTextField {
                    businessEmailTextField.enabled = false
                    popAlertForNoText(self, textFieldNotDisplayingText: textField)
                } else {
                    popAlertForNoText(self, textFieldNotDisplayingText: textField)
                }
                popAlertForNoText(self, textFieldNotDisplayingText: textField)
                return false
            }
        }
        popAlertForNoText(self, textFieldNotDisplayingText: textField)
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textFieldChecker(self.businessNameTextField, indicator: 1) && textFieldChecker(self.businessEmailTextField, indicator: 2) {
//            createBusiness()
            
        self.newBusinessHelper(self.businessNameTextField, email: self.businessEmailTextField, location: placePlacerholder)
            self.performSegueWithIdentifier("iCloudSegue", sender: self)

//            self.appDelegate.reveal()

            return resignFirstResponder()
        }
        return resignFirstResponder()
    }
    func dismissKeyboard(){
        self.setEditing(false, animated: true)
    }
 //MARK CK Custom Functions
    func setUID(business: CKRecord, employee: CKRecord) {
        let timestamp = String(NSDate.timeIntervalSinceReferenceDate())
        let timestampParts = timestamp.componentsSeparatedByString(".")
        UID = timestampParts[0]
        UID.appendContentsOf(timestampParts[1])
        business.setObject(UID, forKey: "UID")
        employee.setObject(UID, forKey: "UID")
        userDefaults.setValue(UID, forKey: "currentBusinessUID")
        userDefaults.setBool(true, forKey: "isEmployee")
    }
    
//    func saveRecords(recordsToSave: [CKRecord]) {
//        let saveOperation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: nil)
//        
//        saveOperation.modifyRecordsCompletionBlock = { saved, deleted, error in
//            if error != nil {
//                print(error)
//            } else {
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
//                        self.performSegueWithIdentifier("success", sender: self)
//                    })
//                })
//            }
//        }
//        publicDatabase.addOperation(saveOperation)
//    }
    
    //MARK: Actions
//    func createBusiness() {
////        loadingAlert("Creating Business...", viewController: self)
//        let newBusiness = CKRecord(recordType: "Businesses")
//        let newUser = CKRecord(recordType: "Employees")
//        
//        let userBizRef = CKReference.init(recordID: newBusiness.recordID, action: .None)
//        newUser.setObject(userBizRef, forKey: "UIDBusinesses")
//        let bizUserRef = CKReference.init(recordID: newUser.recordID, action: .None)
//        newBusiness.setObject(bizUserRef, forKey: "UIDEmployees")
//        
//        newBusiness.setObject(self.businessNameTextField.text, forKey: "Name")
//        newBusiness.setObject(self.businessEmailTextField.text, forKey: "Email")
//        newBusiness.setObject(self.placePlacerholder, forKey: "Location")
//        
//        setUID(newBusiness, employee: newUser)
//        
//        userDefaults.setValue(self.businessNameTextField, forKey: "currentBizName")
//        userDefaults.setBool(true, forKey: "isEmployee")
//        
//        saveRecords([newBusiness, newUser])
//    }
//    

}



