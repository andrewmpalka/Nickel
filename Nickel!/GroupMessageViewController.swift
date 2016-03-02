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

class GroupMessageViewController: SuperViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate , UITextFieldDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var groupMessageSearchBar: UISearchBar!
    @IBOutlet weak var groupMessageTableView: UITableView!
    @IBOutlet weak var sendGroupMessageTextField: UITextField!
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

    
    // method for timeStamp
    let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .ShortStyle)
    
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
    
    // Filtered array of searchbar messages
    var filteredMessages = [String]()
    
    var resultSearchController = UISearchController()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.title = "Message"
        
        // remove search bar border
//        groupMessageSearchBar.backgroundImage = UIImage()
        
        // remove tableview lines
        self.groupMessageTableView.separatorColor = UIColor.clearColor()
        
        // set bar button item fonts
        if let font = UIFont(name: "Avenir", size: 15) {
            menuButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        self.sendGroupMessageTextField.delegate = self
        
        self.groupMessageTableView.separatorColor = UIColor.clearColor()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.groupMessageTableView.tableHeaderView = self.resultSearchController.searchBar
        
        //Adds the search bar at the top of the tableview
        self.groupMessageTableView.reloadData()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        //        saveData()
        
        self.groupMessageTableView.reloadData()

        if userDefaults.objectForKey("currentMessageRecordsForBusinessArray") != nil {
            entiretyOfGroupMessages = userDefaults.objectForKey("currentMessageRecordsForBusinessArray" ) as! [String]
        } else {
            entiretyOfGroupMessages.append("Type something! Start a conversation with your workspace")
        }
    }
    
    //LIMITS KEYBOARD CHARACTERS
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 28    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultSearchController.active {
            return self.filteredMessages.count
        } else {
            return self.entiretyOfGroupMessages.count
        }
        
//        if self.entiretyOfGroupMessages.count > 0 {
//            
//            return self.entiretyOfGroupMessages.count
//        }
//        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupMessageCell") as! GroupMessageTableViewCell
        
        if self.resultSearchController.active {
            cell.textLabel?.text = self.filteredMessages[indexPath.row]
        }
        
        else if self.postAsArrayOfDictionaries.count > 0 {
            
            let contents = self.postAsArrayOfDictionaries[indexPath.row]
            
            let poster = contents["user"] as! CKRecord
            let post = contents["messageString"] as! String
            let timeStamp = contents["timeStampString"] as! String
            
            let imageData = poster.valueForKey("EmployeePic") as! NSData
            
            self.profilePicFromData(imageData)
            let image = self.profilePicture
            
            cell.messageNameLabel.text = post
            cell.messageTimeStamp.text = timeStamp
            cell.messageImageView.image = image
            
        } else {
            
            cell.messageImageView.image = profilePicture
            //        cell.messageImageView.image = UIImage(imageLiteral: "defaultProfile")
            cell.messageNameLabel.text = "Kanye West"
            
            if entiretyOfGroupMessages.count > 0
            {
                cell.groupMessageTextField.text = entiretyOfGroupMessages[indexPath.row]
            }
            else {
                print("Users array: (entiretyOfGroupMessages.description)")
            }
            
            if timeStampOfUsers.count > 0 && timeStampOfUsers.count > indexPath.row
            {
                cell.messageTimeStamp.text = timeStampOfUsers[indexPath.row]
            }
            else {
                print("Timestamp Array: \(timeStampOfUsers.description)")
            }
        }
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        
        self.filteredMessages.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (self.entiretyOfGroupMessages as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredMessages = array as! [String]
        
        self.groupMessageTableView.reloadData()
    }
    
    
    @IBAction func onSendButtonTapped(sender: AnyObject) {
        //TODO add messageString to self.entiretyOfGroupMessages array via .append(messageString)
        //TODO after add, reload self.tableView via self.tableView.reloadData()
        //TODO add the messageString to the userDefaults.setValue(value: self.entiretyOfGroupMessages, forKey:"")
        
        if !(sendGroupMessageTextField.text == "") {
            
            // save data to NS User Defaults
            userDefaults.setObject(sendGroupMessageTextField.text, forKey: "message")
            userDefaults.setObject(timestamp, forKey: "timeStamp")
            userDefaults.synchronize()
            saveData()
            groupMessageTableView.reloadData()
            
            sendGroupMessageTextField.resignFirstResponder()
            sendGroupMessageTextField.text = ""
            
            self.entiretyOfGroupMessages.insert(messageString, atIndex: 0)
            self.timeStampOfUsers.insert(timeStampString, atIndex: 0)
            
            self.groupMessageTableView.reloadData()
            userDefaults.setObject(self.entiretyOfGroupMessages, forKey: "currentMessageRecordsForBusinessArray")

        }
    }
    
    func saveData()
    {
        // display saved data
        if let sentMessage = userDefaults.stringForKey("message")
        {
            messageString = "\(sentMessage)"
            
        }
        if let sentTimeStamp = userDefaults.stringForKey("timeStamp")
        {
            timeStampString = "\(sentTimeStamp)"
            
        }
    }
}




