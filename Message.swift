//
//  Message.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/28/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

class Message: CKRecord {
    
    var sentBy: CKReference?  
    
    var postersName: String?
    var postersPictureAsData: NSData?
    
    var postContents: String?
    var postTimeStampString: String?
}
