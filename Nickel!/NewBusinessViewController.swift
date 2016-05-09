//
//  NewBusinessViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation
import pop


class NewBusinessViewController: SuperViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var businessNameTextField: UITextField!
    
    @IBOutlet weak var locationConstraint: NSLayoutConstraint!
    @IBOutlet weak var continueConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var locationButtonCenter: CGPoint?
    var continueButtonCenter: CGPoint?
    
    var animationEngine: AnimationEngine?
    var originalLocationConstraints: [NSLayoutConstraint]?
    var originalContinueConstraints: [NSLayoutConstraint]?
    
    let locationManager = CLLocationManager() //Jon Code
    
    var placePlacerholder = CLLocation() //prior code
    let appDelegate = AppDelegate()
    
    var UID: String!
    
//    var animationEngine: AnimationEngine!
//    var animationEngine1: AnimationEngine!
//    var animationEngine2: AnimationEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false

        print("reloaded")
        
        self.locationButtonCenter = self.locationButton.center
        self.continueButtonCenter = self.continueButton.center
        
        self.originalLocationConstraints = self.locationButton.constraints
        self.originalContinueConstraints = self.continueButton.constraints
        
//        self.animationEngine = AnimationEngine(constraints: [locationConstraint,
//                                                            continueConstraint])
        self.title = "Nickel"
        self.businessNameTextField.delegate = self
        
        //Locate the businesses current location //Jon Code
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)

        
    }
    
    //Jon Code
    //MARK: Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) -> Void in
            
            if error != nil {
                print("Error: " +  error!.localizedDescription)
                return
            }
            
            //Checks for actual placemarks returned
            self.placePlacerholder = manager.location!
            if placemarks?.count > 0 {
                let pm = placemarks![0] as! CLPlacemark
                self.displayLocationInfo(pm) //custom function to be later defined below
            }
        }
    }
    
    //Jon Code
    func displayLocationInfo(placemark: CLPlacemark) {
        
        self.locationManager.stopUpdatingLocation()
        print(placemark.locality!)
        print(placemark.postalCode!)
        print(placemark.administrativeArea!)
        print(placemark.country!)
        isYourLocation(self, location: placemark)
    }
    
    //Jon Code
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Error: " + error.localizedDescription)
        
    }
    
    
    
//MARK UITextField Functions
    
    func textFieldDidEndEditing(textField: UITextField) {
//        self.locationButton.backgroundColor = SALMON_COLOR
        print("HAPPENING")
    }
    func textFieldChecker(textField: UITextField, indicator: Int) -> Bool {
        
        if(textField.text?.isEmpty == false) {
            if(validateFieldInput(textField.text!, identifier: indicator) == true) {
                self.dismissKeyboard()
                return true
            }
            else {
                textField.textColor = .redColor()
                if textField == businessNameTextField {
//                    businessEmailTextField.enabled = false
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
    
    @IBAction func onAddLocationTapped(sender: AnyObject) {
        //TODO make location popup work
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
  /*      AnimationEngine.animateItemToPosition(self.continueButton, position: self.continueButtonCenter!, completion: {
            (anim: POPAnimation!, finished: Bool) -> Void in
            self.continueButton.addConstraints(self.originalContinueConstraints!)
            print("HITTING THIS")
            
        })
*/
    }
    @IBAction func OnContinueTapped(sender: UIButton) {
        
        if textFieldChecker(businessNameTextField, indicator: 1) {
        BusinessObj.sharedInstance.name = businessNameTextField.text
        BusinessObj.sharedInstance.id = BusinessObj.sharedInstance.name! + "FROM" + UserObj.sharedInstance.device!
        self.newBusinessHelper()
        performSegueWithIdentifier("iCloudSegue", sender: self)
        }
            
        }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textFieldChecker(self.businessNameTextField, indicator: 1) {
//            createBusiness()
            
//TODO MODIFY NewBusinessHelper MOVE IT TO CONTINUE
          /*
            AnimationEngine.animateItemToPosition(self.locationButton, position: self.locationButtonCenter!, completion: {
                (anim: POPAnimation!, finished: Bool) -> Void in
                print("HITTING THIS")
                self.locationButton.addConstraints(self.originalLocationConstraints!)
            })

            */
            print("WORKS")

//            self.appDelegate.reveal()
            self.dismissKeyboard()

            return resignFirstResponder()
            
        }
        
        print("DOESN'T WORK")

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



