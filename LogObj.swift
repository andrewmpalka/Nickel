
//
//  LogObj.swift
//  Nickel28
//
//  Created by Andrew Palka on 5/22/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit


class LogObj {
    static let sharedInstance = LogObj(msg: "This is the activity log")
    
    var msg = ""
    
    var activity = [String]()
    
    
    init(msg: String) {
        self.msg = msg
    }
}
