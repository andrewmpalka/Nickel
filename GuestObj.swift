//
//  GuestObj.swift
//  Nickel28
//
//  Created by Andrew Palka on 5/18/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
class GuestObj: FireObj {
    
    static var sharedInstance = GuestObj(id: "NULL", name: "Anonymous", status: "NULL", profilePic: "NULL", inRange: true, alias: "NULL")
    
    override init(id: String, name: String, status: String, profilePic: String, inRange: Bool, alias: String) {
        super.init(id: id, name: name, status: status, profilePic: profilePic, inRange: inRange, alias: alias)

        self.id = id
        self.name = name
        self.status = status
        self.profilePic = profilePic
        
        self.alias = alias
    }
    
}