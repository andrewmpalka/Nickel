//
//  MessageObj.swift
//  Nickel!
//
//  Created by Jonathan Kilgore on 3/2/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation

class MessageObj {
    let name: String!
    let message: String!
    let from: String!
    let timestamp: String!
    
    init(name: String, message: String, timestamp: String) {
        self.name = name
        self.message = message
        self.from = ""
        self.timestamp = DataServices.generateTimestamp()
    }
    
    init(toUser: String, fromUser: String, message: String, timestamp: String) {
        self.name = toUser
        self.from = fromUser
        self.message = message
        self.timestamp = timestamp
    }
}