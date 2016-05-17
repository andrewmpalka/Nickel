//
//  UserObj.swift
//  Nickel28
//
//  Created by Andrew Palka on 5/9/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Firebase
import GeoFire
import CoreLocation
import UIKit

class UserObj : NSObject {
    static let sharedInstance = UserObj()
    
    var id = String?()
    var device = String?()
    var name = String?()
    var alias = String?()
    var profilepictureURLString = String?()
    var cachedData: AnyObject?
    var geofirePin = "NONE"
    
    
    override init() {
    }
    
    init(id: String, device: String, name: String, alias: String) {
        self.id = id
        self.device = device
        self.name = name
        self.alias = alias
        
        
    }
    
    init(dictionary:[String: AnyObject]) {
        if let idString = dictionary["id"] as? String {
            self.id = idString
        } else {
            userDefaults.setObject(true, forKey: "ERROR_LOG")
            userDefaults.synchronize()
        }
        if let nameString = dictionary["displayName"] as? String {
            self.name = nameString
        } else {
            userDefaults.setObject(true, forKey: "ERROR_LOG")
            userDefaults.synchronize()
        }
        if let aliasString = dictionary["username"] as? String {
            self.alias = aliasString
        } else {
            userDefaults.setObject(true, forKey: "ERROR_LOG")
            userDefaults.synchronize()
        }
        if let url = dictionary["profileImageURL"] as? String {
            self.profilepictureURLString = url
        } else {
            if let ss = dictionary["profileImageURL"] {
            print("PROBLEM")
            
            }
            userDefaults.setObject(true, forKey: "ERROR_LOG")
            userDefaults.synchronize()
        }

        if dictionary["cachedUserProfile"] != nil
        {
            if let data = dictionary["cachedUserProfile"] as? [String: AnyObject] {
                
                var cache = [String: AnyObject]()
                for tuple in data {
                    
                    cache.updateValue(tuple.1, forKey: tuple.0)
                }
                
                    self.cachedData = cache

                
            } else {
                userDefaults.setObject(true, forKey: "ERROR_LOG")
                userDefaults.synchronize()
            }

        } else {
            userDefaults.setObject(true, forKey: "ERROR_LOG")
            userDefaults.synchronize()
        }

        
        
        
    }
    
    func mapToSingletonFromDictionary(dictionary: [String: AnyObject]) {
        let user = UserObj(dictionary: dictionary)
        
        UserObj.sharedInstance.id = user.id!
        UserObj.sharedInstance.name = user.name!
        UserObj.sharedInstance.alias = user.alias!
        UserObj.sharedInstance.profilepictureURLString = user.profilepictureURLString!
//        UserObj.sharedInstance.device = user.device
        UserObj.sharedInstance.cachedData = user.cachedData!
        userDefaults.setObject(false, forKey: "ERROR_LOG")
        userDefaults.synchronize()
        
        
    }
    
}
