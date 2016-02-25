//
//  SuperUIViewController.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/25/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class SuperViewController: UIViewController {
    var CURRENT_USER_RECORD: CKRecord?
    var CURRENT_USER_RID: CKRecordID?
    var CURRENT_BUSINESS_RECORD: CKRecord?
    
    var localUser: User?
    var checkInIndicator = false
}