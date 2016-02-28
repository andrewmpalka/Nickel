//
//  iCloudViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

class iCloudViewController: SuperViewController, UITextFieldDelegate {
    
    var cloudHelper: CKHelper?
    var user: User?
    var window: UIWindow?
    
    
    var bizRecord: CKRecord?
    var newEmployee: CKRecord?
    var employeeRef: CKReference?
    var bizRef: CKReference?
    var employeeArray = [] as NSMutableArray
    var seguedFromMemberSelect: Bool?
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var uidTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Nickel"

        cloudHelper = CKHelper()
        
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        self.iCloudLoginAction()
        loadingAlert("We're working hard to make sure your information stays secure", vc: self)

        
        bizRecord = Business.sharedInstance
//        self.uidTextField.delegate = self
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return resignFirstResponder()
    }
    //MARK iCloud Authentication
    // Action to be called when the user taps "login with iCloud"
    func iCloudLoginAction() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.iCloudLogin({ (success) -> () in
            if success {
                userDefaults.setObject(true, forKey: "Logged in")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewControllerWithIdentifier("revCon") as! SWRevealViewController
                self.localUser = self.user

                self.uniqueMemberNameCheck()

                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.presentViewController(viewController, animated: false, completion: nil)
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            } else {
                // TODO error handling
            }
        })
    }
    
    // Nested CloudKit requests for permission; for getting user record and user information.
    private func iCloudLogin(completionHandler: (success: Bool) -> ()) {
        self.cloudHelper!.requestPermission { (granted) -> () in
            if !granted {
                let iCloudAlert = UIAlertController(title: "iCloud Error", message: "There was an error connecting to iCloud. Check iCloud settings by going to Settings > iCloud.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                iCloudAlert.addAction(okAction)
                self.presentViewController(iCloudAlert, animated: true, completion: nil)
            } else {
                self.cloudHelper!.getUser({ (success, user) -> () in
                    if success {
                        self.user = user
                        self.cloudHelper!.getUserInfo(self.user!, completionHandler: { (success, user) -> () in
                            if success {
                                completionHandler(success: true)
                            }
                        })
                    } else {
                        // TODO error handling
                    }
                })
            }
        }
    }
    //MARK User Record Check
    func tiedToBusiness() -> Bool {
        publicDatabase.fetchRecordWithID((newEmployee?.recordID)!) { record, error in
        }
        if newEmployee?.recordID != nil {
            return true
        }
        return false
    }
    func uniqueMemberNameCheck() {
        if bizRecord?.mutableArrayValueForKey("UIDEmployees").count == 0 {
            createMember()
        } else {
            for employeeReference in (bizRecord?.mutableArrayValueForKey("UIDEmployees"))! {
                publicDatabase.fetchRecordWithID(employeeReference.recordID, completionHandler: { (resultRecord, error) -> Void in
                    
                    if error != nil {
                        print("Error Fetching Names for Uniequness Test: \(error?.description)")
                    } else {
                        
                        if resultRecord!["Name"] as? String == self.localUser?.name {
                            dispatch_async(dispatch_get_main_queue()) {
//                                self.dismissViewControllerAnimated(true, completion: { () -> Void in
//                                    self.errorAlert("Error", message: "\(self.bizRecord!["Name"]!) is already an employee here. Please logout of other device")
//                                })
                            }
                        } else {
                            self.createMember()
                        }
                    }
                })
            }
        }
        
    }
//MARK: Attaching New Employee To Biz
    func joinBiz() {
        
//        uidTextField.resignFirstResponder()
        
        let predicate = NSPredicate(format: "uid == %@", uidTextField.text!)
        let query = CKQuery(recordType: "Businesses", predicate: predicate)
        loadingAlert("Joining Group...", vc: self)
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print("error getting organization: \(error)")
            } else {
                if results != nil {
                    if (results!.count > 0) {
//                        self.orgRecordToJoin = results![0]
                        
                        dispatch_async(dispatch_get_main_queue()) {
//                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
//                                self.performSegueWithIdentifier("", sender: self)
                            }
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
//                                self.errorAlert("Oops!", message: "That invite code doesn't exist. Please try again.")
                            })
                        }
                    }
                }
            }
        }
    func createMember() {
        if newEmployee == nil {
            newEmployee = CKRecord(recordType: "Employees")
            newEmployee!.setValue(localUser?.name, forKey: "Name")
            
            bizRef = CKReference(recordID: bizRecord!.recordID, action: .None)
            newEmployee!.setValue(bizRef, forKey: "UIDBusiness")
            
            employeeRef = CKReference(recordID: newEmployee!.recordID, action: .None)
            
            setReferencesForBiz()
        }
    }
    
    func setReferencesForBiz() {
        if bizRecord!.mutableArrayValueForKey("UIDEmployees").count == 0 {
            employeeArray = [employeeRef!]
            bizRecord?.setObject(employeeArray, forKey: "UIDEmployees")
            modifyRecords([bizRecord!, newEmployee!])
        } else {
            employeeArray = bizRecord!.mutableArrayValueForKey("UIDEmployees")
            employeeArray.addObject(employeeRef!)
//                            orgRecord?.setObject(memberArray, forKey: "members")
            modifyRecords([bizRecord!, newEmployee!])
        }
    }
    
    func modifyRecords (records: [CKRecord]) {
        print("Modify records function called")
        let saveRecordsOperation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        
        saveRecordsOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if error != nil {
                print("error saving member and organization: \(error!.description)"
                )
            }else {
                print("Successfully saved")
            }
            dispatch_async(dispatch_get_main_queue()) {
                //                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                //                    self.performSegueWithIdentifier("logInSegue", sender: self)
                //                })
            }
        }
        publicDatabase.addOperation(saveRecordsOperation)
    }
}


