//
//  FireObj.swift
//  Nickel28
//
//  Created by Andrew Palka on 5/18/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class FireObj: NSObject {
    var id: String?
    var name: String?
    var status: String!?
    var profilePic: String?
    let inRange: Bool?
    var alias: String?
    
    
    init(id: String, name: String, status: String, profilePic: String, inRange: Bool, alias: String) {
        self.id = id
        self.name = name
        self.status = status
        self.profilePic = profilePic
        self.inRange = inRange
        self.alias = alias
    }

}
