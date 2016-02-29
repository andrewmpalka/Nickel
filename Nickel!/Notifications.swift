//
//  Notifications.swift
//  Nickel!
//
//  Created by Jonathan Kilgore on 2/29/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation
import UIKit

class Notifications {
    
    class func display(text: String){
        
        let notification: UILocalNotification = UILocalNotification()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        
        let dateTime = NSDate()
        notification.fireDate = dateTime
        notification.alertBody = text
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
}