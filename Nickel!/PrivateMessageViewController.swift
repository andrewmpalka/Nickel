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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageTableView.separatorColor = UIColor.clearColor()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
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
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! PrivateMessageTableViewCell
        cell.pmImageView?.image = UIImage(imageLiteral: "Kanye")
        cell.pmNameLabel.text = "Kanye West"
        cell.pmTimeStamp?.text = "4:20 PM"
        cell.pmTextField.text = "Hi Kany! I think you are super cool! Hi Kany! I think you are super cool! Hi Kany! I think you are super cool!"

        return cell
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {

        self.resignFirstResponder()
    }

    @IBAction func privateMessageSendButtonPressed(sender: AnyObject) {

        enterPrivateMessageTextField.resignFirstResponder()
    }





}
