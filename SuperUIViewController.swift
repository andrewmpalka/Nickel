//
//  SuperUIViewController.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/25/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class SuperViewController: UIViewController {
    var CURRENT_USER_RECORD: CKRecord?
    var CURRENT_USER_RID: CKRecordID?
    var CURRENT_BUSINESS_RECORD: CKRecord?
    
    var localUser: User?
    var checkInIndicator = false
    var profilePicture: UIImage?
    
}

extension SuperViewController {
    func userGrabAndToss() -> User {
        let string = userDefaults.valueForKey("userRecordID") as! String
        print(string)
        let rID = CKRecordID(recordName: string)
        print("\(rID)" + "RID")
        return User(userRecordID: rID)
    }
    
    func updateVCList() {
        for vc in SuperVCList {
            vc.localUser = self.localUser
        }
    }
    func businessSplitter(biz: Business) {
        
    }
    
    func userSplitter(user: User) {
        let name = user.firstName! + " " + user.lastName!
        let nickname = user.nickname!
        let recordID = user.userRecordID
        
        let userPropertiesDictionary:NSDictionary = ["name" : name, "nickname" : nickname, "recordID" : recordID]
        
        userDefaults.setValue(userPropertiesDictionary, forKey: "sharedInstanceOfUserAsDictionary")
    }
    func digitizePicture(pic: UIImage) -> NSData {
        let data = UIImagePNGRepresentation(pic)
        return data!
    }
    func profilePicFromData(data: NSData) {
        profilePicture = UIImage(data: data, scale: 1)
    }
}
