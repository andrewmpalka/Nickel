//
//  MenuViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class MenuViewController: SuperViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(Array(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys).count)


        // Do any additional setup after loading the view.
    }

    @IBAction func signOutButtonTapped(sender: AnyObject) {

    self.signOut()

    }
 
    @IBAction func adminButtonTapped(sender: AnyObject) {
    }

    func signOut()
    {
        
        DataServices.occupantSignedOut()
        
        let dict: [String: AnyObject] = userDefaults.dictionaryRepresentation()
        for value in dict {
            let key = value.0
            userDefaults.removeObjectForKey(key)
        }
        BusinessObj.sharedInstance.city = nil
        BusinessObj.sharedInstance.status = nil
        BusinessObj.sharedInstance.location = nil
        BusinessObj.sharedInstance.profilePic = nil
        BusinessObj.sharedInstance.name = nil
        UserObj.sharedInstance.alias = nil
        UserObj.sharedInstance.name = "NULL"
        UserObj.sharedInstance.device = "Newbie"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("rootNav") as! UINavigationController
        self.presentViewController(viewController, animated: true) { 
            print("LOG OUT HANDLER AVAILABLE")
        }
    }
}



