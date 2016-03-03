//
//  PrivateMessageViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class PrivateMessageViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var enterPrivateMessageTextField: UITextField!

    var employee: EmployeeObj?
    var messages = [MessageObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Message"

        // remove space on top of cell
        self.automaticallyAdjustsScrollViewInsets = false

        self.messageTableView.separatorColor = UIColor.clearColor()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        DataServices.listenForPrivateMessages { (messages) -> Void in
            self.messages = messages
            self.messageTableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if userDefaults.valueForKey("userPicture") != nil {
            self.profilePicFromData(userDefaults.valueForKey("userPicture") as! NSData)
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
        return self.messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! PrivateMessageTableViewCell
        
        let communication = self.messages[indexPath.row]
        
        cell.pmImageView?.image = profilePicture
//        cell.pmImageView?.image = UIImage(imageLiteral: "defaultProfile")
        cell.pmNameLabel.text = communication.name
        cell.pmTimeStamp?.text = "4:20 PM"
        cell.pmTextField.text = communication.message

        if User.sharedInstance.name != nil {
            cell.pmNameLabel.text = User.sharedInstance.name
        }
        
        return cell
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {

        self.resignFirstResponder()
    }

    @IBAction func privateMessageSendButtonPressed(sender: AnyObject) {
        DataServices.sendPrivateMessage(self.employee!.name, message: self.enterPrivateMessageTextField.text!)
        enterPrivateMessageTextField.text = ""
        enterPrivateMessageTextField.resignFirstResponder()
    }





}
