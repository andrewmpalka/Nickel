//
//  Constants.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/18/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//


import UIKit
import CloudKit

let cka = CloudKitAccess()
let userDefaults = NSUserDefaults.standardUserDefaults()
let container = CKContainer.defaultContainer()
let publicDatabase = container.publicCloudDatabase
let privateDatabase = container.privateCloudDatabase
let businessID = userDefaults.stringForKey("currentBusinessUID")
let memberName = userDefaults.stringForKey("currentUserName")
var CURRENT_USER_RECORD: CKRecord?
var CURRENT_BUSINESS_RECORD: CKRecord?

var localUser: User?
var checkInIndicator = false
//MARK Custom Alerts

func loadingAlert (loadMessage: String, vc: UIViewController){
    let alert = UIAlertController(title: nil, message: loadMessage, preferredStyle: UIAlertControllerStyle.Alert)
    alert.view.tintColor = UIColor.blackColor()
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10,5,50,50)) as UIActivityIndicatorView
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    loadingIndicator.startAnimating()
    
    alert.view.addSubview(loadingIndicator)
    
    vc.presentViewController(alert, animated: true, completion: nil)
    
}

func popAlertForNoText(vc: UIViewController, textFieldNotDisplayingText: UITextField) {
    let noTextAlertController: UIAlertController = UIAlertController(title: "Please enter a valid response" ,
        message: textFieldNotDisplayingText.placeholder,
        preferredStyle: .Alert)
    let noTextAlertAction: UIAlertAction = UIAlertAction(title: "Sorry, won't happen again!",
        style: UIAlertActionStyle.Cancel,
        handler: nil)
    
    noTextAlertController.addAction(noTextAlertAction)
    vc.presentViewController(noTextAlertController, animated: true, completion: nil)
    
}

func welcomePopAlert(vc: UIViewController, currentUser: User) {
    let welcomeAlertController = UIAlertController(title: "Welcome to Nickel, \(currentUser.firstName!) \(currentUser.lastName!)", message: "Ready to check-in to your workspace?", preferredStyle: UIAlertControllerStyle.ActionSheet)
//    let yesAction: UIAlertAction = UIAlertAction(title: "Check Me In", style: UIAlertActionStyle.Default) { (yesAction) -> Void in
//        print("We will eventually check this person in through this")
//        userDefaults.setBool(true, forKey: "Checked")
//        checkInIndicator = true
//    }
    let yesAction: UIAlertAction = UIAlertAction(title: "Check In", style: UIAlertActionStyle.Destructive) { (yesAction) -> Void in
        checkInIndicator = true
    }
    let noAction: UIAlertAction = UIAlertAction(title: "Remind Me Later", style: UIAlertActionStyle.Default) { (noAction) -> Void in
        print("We will eventually add a reminder")
}
    
    welcomeAlertController.addAction(yesAction)
    welcomeAlertController.addAction(noAction)
    vc.presentViewController(welcomeAlertController, animated: true) { () -> Void in
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

