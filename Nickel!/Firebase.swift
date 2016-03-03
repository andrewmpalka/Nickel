//
//  Firebase.swift
//  Nickel!
//
//  Created by Jonathan Kilgore on 3/2/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://nickelapp.firebaseio.com/"

class DataService {
    
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _STATUS_REF = Firebase(url: "\(BASE_URL)/status")
    private var _NAME_REF = Firebase(url: "\(BASE_URL)/name")
    private var _CK_REF = Firebase(url: "\(BASE_URL)/cloudkit")
    private var _BUSINESS_REF = Firebase(url: "\(BASE_URL)/business")
    
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _MESSAGE_REF = Firebase(url: "\(BASE_URL)/messages")


    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var STATUS_REF: Firebase {
        return _STATUS_REF
    }
    
    var NAME_REF: Firebase {
        return _NAME_REF
    }
    
    var CK_REF: Firebase {
        return _CK_REF
    }
    
    var BUSINESS_REF: Firebase {
        return _BUSINESS_REF
    }
    
    var USER_REF : Firebase {
        return _USER_REF
    }
    
    var MESSAGE_REF : Firebase {
        return _MESSAGE_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("employee").childByAppendingPath(userID)
        return currentUser!
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        
        USER_REF.childByAppendingPath(uid).setValue(user)
    }

    func createNewMessage(message: Dictionary<String, AnyObject>) {
        
        let firebaseNewMessage = MESSAGE_REF.childByAutoId()
    
        //Set new value to firebase
        firebaseNewMessage.setValue(message)
    
    }
    
    
    
    
} //end of class
