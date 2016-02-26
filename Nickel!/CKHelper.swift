//
//  CKHelper.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/18/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import CloudKit

class CKHelper: NSObject {
    
    var defaultContainer: CKContainer?
    
    override init() {
        defaultContainer = CKContainer.defaultContainer()
    }
 //logging in with iCloud
    func requestPermission(completionHandler: (granted: Bool) -> ()) {
        defaultContainer!.requestApplicationPermission(CKApplicationPermissions.UserDiscoverability, completionHandler: { applicationPermissionStatus, error in
            if applicationPermissionStatus == CKApplicationPermissionStatus.Granted {
                completionHandler(granted: true)
            } else {
                // very simple error handling
                completionHandler(granted: false)
            }
        })
    }
    
    func getUser(completionHandler: (success: Bool, user: User?) -> ()) {
        defaultContainer!.fetchUserRecordIDWithCompletionHandler { (userRecordID, error) in
            if error != nil {
                completionHandler(success: false, user: nil)
            } else {
//                userDefaults.setValue(userRecordID, forKey: "currentUserRID")
                let privateDatabase = self.defaultContainer!.privateCloudDatabase
                privateDatabase.fetchRecordWithID(userRecordID!, completionHandler: { (user: CKRecord?, anError) -> Void in
                    if (error != nil) {
                        completionHandler(success: false, user: nil)
                    } else {
                        let user = User(userRecordID: userRecordID!)
                        completionHandler(success: true, user: user)
                    }
                })
            }
        }
    }
    
    func getUserInfo(user: User, completionHandler: (success: Bool, user: User?) -> ()) {
        defaultContainer!.discoverUserInfoWithUserRecordID(user.userRecordID) { (info, fetchError) in
            if fetchError != nil {
                completionHandler(success: false, user: nil)
            } else {
                user.firstName = info!.displayContact!.givenName
                user.lastName = info!.displayContact!.familyName
                user.setFullName()
                userDefaults.setValue("\(user)", forKey: "userRecordID")
                print(user.name!)
                print("USER NAME")
                completionHandler(success: true, user: user)
            }
        }
    }
}