//
//  GroupMessageViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class GroupMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var groupMessageSearchBar: UISearchBar!
    @IBOutlet weak var groupMessageTableView: UITableView!
    @IBOutlet weak var sendGroupMessageTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("GroupMessageCell") as! GroupMessageTableViewCell
        cell.messageImageView.image = UIImage(imageLiteral: "Kanye")
        cell.messageNameLabel.text = "Kanye West"
        cell.messageTimeStamp.text = "4:20 PM"
        cell.groupMessageTextField.text = "Hi Kany! I think you are super cool! Hi Kany! I think you are super cool! Hi Kany! I think you are super cool!"

        return cell
    }

    @IBAction func didBeginTypingGroupMessage(sender: AnyObject) {
    }

    @IBAction func sendGroupMessageButtonPressed(sender: AnyObject) {
        resignFirstResponder()
    }

}
