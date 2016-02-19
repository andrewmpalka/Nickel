//
//  ListViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var membersOnlineLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.layer.borderColor = UIColor.clearColor().CGColor

        self.tableView.separatorColor = UIColor.clearColor()

        self.automaticallyAdjustsScrollViewInsets = false

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let record = CKRecord(recordType: "Businesses", recordID: (CURRENT_BUSINESS_RECORD_ID!))
        print(record.valueForKey("Name") as? String)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("CellID") as! TableViewCell
        cell.cellImageView?.image = UIImage(imageLiteral: "Kanye")
        cell.cellGreenLightImage.image = UIImage(imageLiteral: "salmonLight")
        cell.cellTitleLabel.text = "Kanye West"
        cell.detailTextLabel?.text = "@kanye"

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }



}
