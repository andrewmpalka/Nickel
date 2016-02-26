//
//  Model.swift
//  Nickel!
//
//  Created by Andrew Palka on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import CloudKit

protocol ModelDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}
class Model {
    
    static let sharedInstance = Model()
    
//    class func sharedInstance() -> Model {
    
//        return modelSingletonGlobal
//    }
    
    var delegate : ModelDelegate?
    
    let container : CKContainer
    let publicDB : CKDatabase
    let privateDB : CKDatabase
    
    init() {
        container = CKContainer.defaultContainer() //1
        publicDB = container.publicCloudDatabase //2
        privateDB = container.privateCloudDatabase //3
    }
}

