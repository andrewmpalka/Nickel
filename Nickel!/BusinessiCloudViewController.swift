//
//  BusinessiCloudViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class BusinessiCloudViewController: SuperViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    var cloudHelper: CKHelper?
    var aUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false

        self.title = "Nickel"

        cloudHelper = CKHelper()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.iCloudLoginAction()
        loadingAlert(self)
        return resignFirstResponder()
    }
    // Action to be called when the user taps "login with iCloud"
    func iCloudLoginAction() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.iCloudLogin({ (success) -> () in
            if success {
                userDefaults.setBool( true, forKey: "Logged in")
                self.newEmployeeHelperForBusiness((Business.sharedInstance))
                

                NSOperationQueue.mainQueue().addOperationWithBlock {
                    alertConst.dismissViewControllerAnimated(true, completion: nil)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewControllerWithIdentifier("revCon") as! SWRevealViewController

                    self.presentViewController(viewController, animated: false, completion: nil)
                   UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            } else {
                //MARK: TODO error handling
            }
        })
    }
    
    //MARK: Nested
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
                        print("\(user!.userRecordID)")
//                        userDefaults.setValue("\(user!.userRecordID)", forKey: "userRecordID")
                        self.aUser = user
                        print("\(self.aUser!.userRecordID)")

                        self.cloudHelper!.getUserInfo(self.aUser!, completionHandler: { (success, user) -> () in
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
