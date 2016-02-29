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

class GroupMessageViewController: SuperViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var groupMessageSearchBar: UISearchBar!
    @IBOutlet weak var groupMessageTableView: UITableView!
    @IBOutlet weak var sendGroupMessageTextField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    // empty string for Message
    var messageString = ""

    // empty string for User
    var userName = ""

    // empty array for Messages
    var entiretyOfGroupMessages: [String] = []

    // empty arry for Users
    var entiretyOfUsers: [String] = []


    // delclare delegate property
//    var delegate: EditMessageViewControllerDelegate!

    // make an array of type CKRecord
//    var messagesArray: Array<CKRecord> = []

    // declare property. the "editedNoteRecored" is the CDRecord object the should be edited after it is selected
//    var editedMessageRecord: CKRecord!

//    var messageRecord: CKRecord!

    override func viewDidLoad() {
        super.viewDidLoad()

        saveData()

        self.title = "Message"


        // remove search bar border
        groupMessageSearchBar.backgroundImage = UIImage()

        // remove tableview lines
        self.groupMessageTableView.separatorColor = UIColor.clearColor()

        // set bar button item fonts
        if let font = UIFont(name: "Avenir", size: 15) {
            menuButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }

        
        self.groupMessageTableView.separatorColor = UIColor.clearColor()

//        fetchMessages()

//        if let editedMessage = editedMessageRecord
//        {
//        sendGroupMessageTextField.text = editedMessage.valueForKey("PubliceMessage") as? String
//        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

        if self.revealViewController() != nil {

            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(true)

        self.groupMessageTableView.reloadData()

        if userDefaults.objectForKey("currentMessageRecordsForBusinessArray") != nil {
            entiretyOfGroupMessages = userDefaults.objectForKey("currentMessageRecordsForBusinessArray" ) as! [String]
        }
    }

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
        if self.entiretyOfGroupMessages.count > 0 {

            return self.entiretyOfGroupMessages.count
        }

        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("GroupMessageCell") as! GroupMessageTableViewCell

        // assign each object of the arrNotes array to a local variable
//        let messageRecord: CKRecord = messagesArray[indexPath.row]

//        cell.groupMessageTextField.text = messageRecord.valueForKey("PubliceMessage") as? String

        // convert date to a String using NSDateForamatter
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm"

//        cell.messageTimeStamp.text = dateFormatter.stringFromDate(messageRecord.valueForKey("Timestamp") as! NSDate)

        cell.messageImageView.image = UIImage(imageLiteral: "defaultProfile")

        cell.messageNameLabel.text = "Kanye West"

        cell.messageTimeStamp.text = "4:20 PM"



        cell.messageTimeStamp.text = "4:20 PM"
        if !(sendGroupMessageTextField.text == "")
        {
        cell.groupMessageTextField.text = entiretyOfGroupMessages[indexPath.row]
        }
        else {
            cell.groupMessageTextField.text = "Type something! Start a conversation with your workspace"
        }
        saveData()
        return cell
    }

    @IBAction func DismissKeyboard(sender: AnyObject) {

        self.resignFirstResponder()
    }

    @IBAction func onSendButtonTapped(sender: AnyObject) {
//TODO add messageString to self.entiretyOfGroupMessages array via .append(messageString)
//TODO after add, reload self.tableView via self.tableView.reloadData()
//TODO add the messageString to the userDefaults.setValue(value: self.entiretyOfGroupMessages, forKey:"")

        if !(sendGroupMessageTextField.text == "") {

            // save data to NS User Defaults
            userDefaults.setObject(sendGroupMessageTextField.text, forKey: "message")
            userDefaults.synchronize()
            saveData()

            sendGroupMessageTextField.resignFirstResponder()
            sendGroupMessageTextField.text = ""

            self.entiretyOfGroupMessages.insert(messageString, atIndex: 0)

            self.groupMessageTableView.reloadData()
            userDefaults.setObject(self.entiretyOfGroupMessages, forKey: "currentMessageRecordsForBusinessArray")


//            addMessageToBusinessMessageList(<#T##bizRec: CKRecord##CKRecord#>, employeeRec: <#T##CKRecord#>, messageRec: <#T##CKRecord#>, message: <#T##String#>)

//        var messageRecord: CKRecord!
//        var isEditingMessage: Bool!   // Flag declaration.
//
//        if let editedMessage = editedMessageRecord {
//            messageRecord = editedMessage
//
//            isEditingMessage = true // True because a note record has been edited.
//        }
//
//        else
//        {
//
//        // add a time stamp and use it as a unique identifier
//        let timestampAsString = String(format: "%f", NSDate.timeIntervalSinceReferenceDate())
//        let timestampParts = timestampAsString.componentsSeparatedByString(".")
//
//        // create "messageID" object which is the key to new record
//        let messageID = CKRecordID(recordName: timestampParts[0])
//
//        // set messageRecord to the data we want to be saved and set the values
//
////        messageRecord = CKRecord(recordType: "Users", recordID: messageID)
//
//            isEditingMessage = false   // False because it's a new note record.
//        }
//        messageRecord.setObject(sendGroupMessageTextField.text, forKey: "PublicMessage")
//        messageRecord.setObject(NSDate(), forKey: "Timestamp")
//
//        // specify the container that is used in the app (in this case the default public one)
//        let container = CKContainer.defaultContainer()
//        let publicDatabase = container.publicCloudDatabase
//
//        // now we can SAVE the record to CLOUDKIT
//        publicDatabase.saveRecord(messageRecord, completionHandler: { (record, error) -> Void in
//            if (error != nil) {
//                print(error)
//            }
//                // call the delegate method we declared with else case the indicates saving succussful
//            else {
//                self.delegate.didSaveMessage(messageRecord, wasEditingMessage: isEditingMessage)
//            }
//        })
//
//        sendGroupMessageTextField.resignFirstResponder()
//    }
//}
//
//    // access the default container and the private database and creatate a query object so we can get the records we want
//
//    func fetchMessages() {
//
//        // specify the container that is used in the app (in this case the default public one)
//        let predicate = NSPredicate(value: true)
//
//        // CKQuesry accepts two arguments, the name of the record scheme (notes) and the predicate
//        let query = CKQuery(recordType: "Users", predicate: predicate)
//
//        // now run the query
//        privateDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
//            if error != nil {
//                print(error)
//            }
//            else {
//                // print results so you can see what the fetched records contain
//                print(results)
//
//                // keep all the found records in the arrNotes array
//                for result in results! {
//                    self.messagesArray.append(result as! CKRecord)
//                }
//
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    self.groupMessageTableView.reloadData()
//                    self.groupMessageTableView.hidden = false
//                })
//            }
        }
    }

    func saveData()
    {
        // display saved data
        if let sentMessage = userDefaults.stringForKey("message")
        {
            messageString = "\(sentMessage)"

        }
    }

}
