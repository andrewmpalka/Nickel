//
//  BusinessObj.swift
//  Nickel28
//
//  Created by Andrew Palka on 5/9/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessObj {
    static var sharedInstance = BusinessObj(id: "NULL", name: "NULL", profilePic: "NONE", location: CLLocation())
    
    
    
    var id: String?
    var name: String?
    var location: CLLocation?
    var status: String?
    var profilePic: String?
    var city: String?
    
    init(id: String, name: String, profilePic: String, location: CLLocation) {
        self.id = id
        self.name = name
        self.profilePic = profilePic
        self.location = location
    }

}
