//
//  Constants.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/18/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

let mattImage = UIImage(imageLiteral: "matt")
let andyImage = UIImage(imageLiteral: "jon")
let jonImage = UIImage(imageLiteral: "andy")

let userProfilePicDict: [String: UIImage] = ["Matt Deuschle": mattImage, "Andrew Palka": andyImage, "Jonathan Kilgore": jonImage]

let SALMON_COLOR = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1.0)
let DARK_GRAY_COLOR = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
let LIGHT_GRAY_COLOR = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)

let cka = CloudKitAccess()
let userDefaults = NSUserDefaults.standardUserDefaults()
let container = CKContainer.defaultContainer()
let publicDatabase = container.publicCloudDatabase
let privateDatabase = container.privateCloudDatabase

let businessID = userDefaults.stringForKey("currentBusinessUID")
let memberID = userDefaults.stringForKey("currentUserRID")

let userString = userDefaults.valueForKey("userRecordID") as! String
let businessString = userDefaults.valueForKey("businessRecordID") as! String

let memberName = userDefaults.stringForKey("currentUserName")
//let checkIndicator = userDefaults.boolForKey("checkIn")
let businessName = userDefaults.stringForKey("currentBusinessName")
let businessLocation = userDefaults.stringForKey("currentBusinessLocation")
let businessEmail = userDefaults.stringForKey("currentBusinessEmail")

let defaultUser = userDefaults.valueForKey("sharedInstanceOfUserAsDictionary")
let defaultUserDictionary = defaultUser as! NSDictionary

let defaultProfilePic = userDefaults.valueForKey("userPicture")

let currentUserProfilepic = userDefaults.valueForKey("employeePic")
let allEmployeesProfilePicsArray = userDefaults.valueForKey("allEmployeesPics")


let defaultEmployeeRecordsForBusinessArray = userDefaults.valueForKey("currentEmployeeRecordsArray")
let defaultMessageRecordsForBusinessArray = userDefaults.valueForKey("currentMessageRecordsForBusinessArray")

let defaultVisibleEmployeeRecordIDsAsArrayOfString = userDefaults.valueForKey("visibleEmployees")


let alertConst = UIAlertController(title: "One moment, please", message: "We are setting up your workspace", preferredStyle: UIAlertControllerStyle.ActionSheet)





//MARK: Custom Alerts

func isYourLocation(vc: SuperViewController, location: CLPlacemark) {
    let alert = UIAlertController(title: "Is your location correct?", message: "\n\( location.locality!), \(location.administrativeArea!)", preferredStyle: UIAlertControllerStyle.ActionSheet)
    let action1 = UIAlertAction(title: "Yes", style: .Destructive) { action in
        alert.removeFromParentViewController()
        BusinessObj.sharedInstance.location = location.location
    }
    let action2 = UIAlertAction(title: "Retry", style: .Destructive) { action in
        
    }
    let action3 = UIAlertAction(title: "Cancel", style: .Destructive) { action in
        
    }
    alert.addAction(action1)
    alert.addAction(action2)
    alert.addAction(action3)
    
    vc.presentViewController(alert, animated: false) { () in
    }

}

func loadingAlert (vc: SuperViewController){
//    let alert = UIAlertController(title: "One moment, please", message: loadMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
//    alert.view.tintColor = DARK_GRAY_COLOR
//    alert.view.backgroundColor = LIGHT_GRAY_COLOR

    let action = UIAlertAction(title: "Cancel", style: .Destructive) { alertAction in
//        loadingIndicator.stopAnimating()
    }
    
    

    alertConst.addAction(action)
    vc.presentViewController(alertConst, animated: true, completion: nil)
    
}

func popAlertForNoText(vc: SuperViewController, textFieldNotDisplayingText: UITextField) {
    let noTextAlertController: UIAlertController = UIAlertController(title: "Please enter a valid response" ,
        message: "A business name should have at least 4 characters. \nTry adding \", Inc.\" if your name is too short",
        preferredStyle: .Alert)
    let noTextAlertAction: UIAlertAction = UIAlertAction(title: "Sorry, won't happen again!",
        style: UIAlertActionStyle.Cancel,
        handler: nil)
    
    noTextAlertController.addAction(noTextAlertAction)
    vc.presentViewController(noTextAlertController, animated: true, completion: nil)
    
}

func deviceInUseAlertPop(vc: SuperViewController, user: User) {
    let deviceAlertController: UIAlertController = UIAlertController(title: "Please sign out of other device" ,
        message: user.firstName! + ", you are already logged into this workspace",
        preferredStyle: .Alert)
    let noDeviceAlertAction: UIAlertAction = UIAlertAction(title: "Sorry, won't happen again!",
        style: UIAlertActionStyle.Cancel,
        handler: nil)
    
    deviceAlertController.addAction(noDeviceAlertAction)
    vc.presentViewController(deviceAlertController, animated: true, completion: nil)
    
}

func welcomePopAlert(vc: SuperViewController, currentUser: User) {
    let welcomeAlertController = UIAlertController(title: "Welcome to Nickel, \(currentUser.name!)", message: "Ready to check-in to your workspace?", preferredStyle: UIAlertControllerStyle.ActionSheet)
    //    let yesAction: UIAlertAction = UIAlertAction(title: "Check Me In", style: UIAlertActionStyle.Default) { (yesAction) -> Void in
    //        print("We will eventually check this person in through this")
    //        userDefaults.setBool(true, forKey: "Checked")
    //        checkInIndicator = true
    //    }
    let yesAction: UIAlertAction = UIAlertAction(title: "Check in", style: UIAlertActionStyle.Destructive) { (yesAction) -> Void in
        
        userDefaults.setValue(true, forKey: "checkIn")
        print("checked in~~~~~~~~~~~~~~~~~~")
        print(vc.checkIndicator)
        vc.controllerThatNeedsToBeDismissed = welcomeAlertController
        userDefaults.setValue(true, forKey: "Logged in")
    }
    let noAction: UIAlertAction = UIAlertAction(title: "Remind me later", style: UIAlertActionStyle.Destructive) { (noAction) -> Void in
        print("We will eventually add a reminder")
    }
    welcomeAlertController.addAction(yesAction)
    
    welcomeAlertController.addAction(noAction)
    vc.presentViewController(welcomeAlertController, animated: false) { () -> Void in
        print("Code will eventually go here")
    }
}



func validateFieldInput (text : String, identifier: Int) -> Bool {
    var regex = String?()
    
    switch(identifier) {
    case 1:    if text.characters.count > 3 {
        return true
    } else {
        return false
        }
    case 2:     regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
    default:
        return false
    }
    
    let range = text.rangeOfString(regex!, options: .RegularExpressionSearch)
    let result = range != nil ? true : false
    return result
}

//MARK: Custom Functions

func fetchPublicDataFromCloud(recType: String) {
    let privateDatabase = container.privateCloudDatabase
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: recType, predicate: predicate)
}

func startTimerForCheckin() {
    
}