//
//  EmployeeObj.swift
//  Nickel!
//
//  Created by Jonathan Kilgore on 3/2/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation

class EmployeeObj: FireObj {
    
    static var sharedInstance = EmployeeObj(id: "NULL", name: "NULL", status: "NULL", profilePic: "NULL", inRange: true, alias: "NULL")
    

//    var id: String?
//    var name: String?
//    var status: String!?
//    var profilePic: String?
//    let inRange: Bool?
//    var alias: String?
    

    override init(id: String, name: String, status: String, profilePic: String, inRange: Bool, alias: String) {
        super.init(id: id, name: name, status: status, profilePic: profilePic, inRange: inRange, alias: alias)
        self.id = id
        self.name = name
        self.status = status
        self.profilePic = profilePic
        self.alias = alias
    }
    
}