//
//  GroupMessageViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

// noteRecord is actual CKRecord we pass to the ListVC, the second parameter indicates whether the record is new or not, bc if new, it will just append the arrNotes array. If edited, then it will replace the proper CKRecord object to the arrNotes array
//protocol EditMessageViewControllerDelegate {
//    func didSaveMessage(messageRecord: CKRecord, wasEditingMessage: Bool)
//}

class GroupMessageViewController: SuperViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
  //  @IBOutlet weak var groupMessageSearchBar: UISearchBar!
    @IBOutlet weak var groupMessageTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!


    
    // empty string for Message
    var messageString = ""
    //V IMPORTANT
    var postAsArrayOfDictionaries: [NSDictionary] = []
    /*
    Each dictionary is a unique post, seperated into keys
    
    "user": Employee.sharedInstance
    "messageString": messageString
    "timeStampString": timeStampString

    */

    var messages = [MessageObj]()
    
//    // method for timeStamp
//    let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .ShortStyle)

    // empty string for TimeStamp
    var timeStampString = ""
    
    // empty string for User
    var userName = ""
    
    // empty array for Messages
    var entiretyOfGroupMessages: [String] = []
    
    // empty arry for TimeStamp
    var timeStampOfUsers: [String] = []
    
    // empty array for Users
    var entiretyOfUsers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // remove space on top of cell
        self.automaticallyAdjustsScrollViewInsets = false

//        self.groupMessageTableView.reloadData()

        self.title = "Activity Log"
        
        // remove search bar border
  //      groupMessageSearchBar.backgroundImage = UIImage()
        
        // remove tableview lines
        self.groupMessageTableView.separatorColor = UIColor.clearColor()
        
        // set bar button item fonts
        if let font = UIFont(name: "Avenir", size: 15) {
            menuButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
        self.groupMessageTableView.separatorColor = UIColor.clearColor()
        
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        //        saveData()
        
        
        DataServices.listenForActivityLog { (log) in
            LogObj.sharedInstance.activity = log
            print("HEY LISTEN")
            print(log)
            self.groupMessageTableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if LogObj.sharedInstance.activity.count != 0 {
          return LogObj.sharedInstance.activity.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupMessageCell")

    // TRYING TO ADD PICS
        cell?.textLabel!.text = LogObj.sharedInstance.activity[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "Avenir", size: 15)
        
        let size = CGSize(width: self.view.frame.width, height: 40.0)
        cell?.textLabel?.sizeThatFits(size)
        
    

//        cell.messageTimeStamp.text = timeStampString

        
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    

}




