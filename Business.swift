//
//  Business.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import CloudKit

class Business: CKRecord {

    static var sharedInstance = CKRecord(recordType: "Businesses")
    
    var name: String?
    var email: String?
    
    var beacons: [String]?
    var employees: [String]?
    
    var currentAvgTimestamp: Double?
    var avgTimestampList: [Double]?
    
    var UIDEmployees: [CKReference]?
    
    var location: CLLocation?
    
    var timestampList: [NSDate]?
    
    var employeePictureListAsData: [NSData]?
    
    var companyProfilePicture: NSData?
    
    
}