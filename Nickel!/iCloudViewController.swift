//
//  iCloudViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class iCloudViewController: UIViewController {
    
        var cloudHelper: CKHelper?
        var user: User?
        var window: UIWindow?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            cloudHelper = CKHelper()
            self.iCloudLoginAction()

        }
    
        // Action to be called when the user taps "login with iCloud"
        func iCloudLoginAction() {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            self.iCloudLogin({ (success) -> () in
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewControllerWithIdentifier("navCon") as! UINavigationController
                    localUser = self.user
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
        
}
