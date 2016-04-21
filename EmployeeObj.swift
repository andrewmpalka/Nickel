//
//  EmployeeObj.swift
//  Nickel!
//
//  Created by Jonathan Kilgore on 3/2/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation

class EmployeeObj {
    let name: String!
    let status: String!
    let inRange: Bool!

    init(name: String, status: String, inRange: Bool) {
        self.name = name
        self.status = status
        self.inRange = inRange
    }
}