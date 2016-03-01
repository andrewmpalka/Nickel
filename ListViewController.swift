//
//  ListViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

class ListViewController: SuperViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var numberOfUsersOnlineButton: UIBarButtonItem!
    
    var memberArray = [CKRecord]()
    var currentBusiness: CKRecord?
    var checker = false
    
    var aUser = User?()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set bar button item fonts
        if let font = UIFont(name: "Avenir", size: 15) {
            menuButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
//            numberOfUsersOnlineButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }

        self.title = "Nickel"

        // remove cell lines
        self.tableView.separatorColor = UIColor.clearColor()

        // remove space on top of cell
        self.automaticallyAdjustsScrollViewInsets = false
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if (userDefaults.valueForKey("Logged in") == nil) {
            print(userString)
            let recID = CKRecordID(recordName: userString)
            User.sharedInstance.userRecordID = recID
            self.aUser = self.userGrabAndToss()
            print(User.sharedInstance.name!)
            welcomePopAlert(self, currentUser: User.sharedInstance)
//        }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        if userDefaults.valueForKey("userPicture") != nil {
            self.profilePicFromData(userDefaults.valueForKey("userPicture") as! NSData)
        }
        //        let record = CKRecord(recordType: "Businesses", recordID: (CURRENT_BUSINESS_RECORD_ID!))
        //        print(record.valueForKey("Name") as? String)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID") as! TableViewCell
        cell.cellImageView?.image = UIImage(imageLiteral: "defaultProfile")
        cell.cellGreenLightImage.image = UIImage(imageLiteral: "salmonLight")
        cell.cellTitleLabel.text = "Kanye West"
        cell.detailTextLabel?.text = "@Kanye"
        cell.cellGreenLightImage.hidden = false
        
        //For data saved to Cloudkit will override the default cell
        if profilePicture != nil {
            cell.cellImageView.image = profilePicture
        }
        
        if User.sharedInstance.name != nil {
            cell.cellTitleLabel.text = User.sharedInstance.name
        }
        
        if User.sharedInstance.nickname != nil {
            cell.detailTextLabel?.text = User.sharedInstance.nickname
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Fetching CKData
    
    func getBusiness() {
        let predicate = NSPredicate(format: "UID == %@", businessID!)
        let query = CKQuery(recordType: "Organization", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil) { (organizations, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("performing query, Businesses: \(organizations![0]["name"])")
                self.currentBusiness = organizations![0] as CKRecord
                self.getTasks()
            }
        }
    }
    
    func getTasks() {
        let taskReferenceArray = currentBusiness!.mutableArrayValueForKey("tasks")
        for taskRef in taskReferenceArray {
            publicDatabase.fetchRecordWithID(taskRef.recordID, completionHandler: { (task, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    if task != nil {
                        self.memberArray.append(task!)
                        print("appended task: \(task)")
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    
}
