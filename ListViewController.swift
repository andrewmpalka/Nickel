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
    
    var memberArray = [CKRecord]?()
    var insideFieldMembers = [CKRecord]?()
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
//        self.fetchUsers()
        
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
        }
        
//        self.updateUsersOnlineLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.fetchUsers()
        self.updateUsersOnlineLabel()
        
        if userDefaults.valueForKey("userPicture") != nil {
            self.profilePicFromData(userDefaults.valueForKey("userPicture") as! NSData)
        }
        
        
    }
    
    func updateUsersOnlineLabel() {
        self.numberOfUsersOnlineButton.title = String(stringInterpolationSegment: memberArray!.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.memberArray!.count > 0 {
            
            return self.memberArray!.count
        } else {
            self.viewDidLoad()
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID") as! TableViewCell
        
        
        if User.sharedInstance.name != nil {
            cell.cellTitleLabel.text = User.sharedInstance.name
        }
        if User.sharedInstance.nickname != nil {
            cell.detailTextLabel?.text = User.sharedInstance.nickname
        }
        
        //Andy's code
        if self.memberArray!.count > 0 {
            let member = memberArray![indexPath.row]
            
            if member.valueForKey("ProfilePictureAsNSData") != nil {
                let data = member.valueForKey("ProfilePictureAsNSData") as! NSData
            }
            //        let pic = self.profilePicFromData(data)
            
            cell.cellGreenLightImage.image = UIImage(imageLiteral: "salmonLight")
            if profilePicture != nil {
                cell.cellImageView.image = profilePicture
            } else {
                cell.cellImageView.image = UIImage(imageLiteral: "defaultProfile")
            }
            
            if member.valueForKey("InsideField") as! Int == 1 {
            cell.cellGreenLightImage.hidden = false
            }
            print(member.recordID.recordName)
            cell.cellTitleLabel.text = (member.valueForKey("Name") as! String)
            cell.cellDetailLabel.text = (member.valueForKey("Nickname")! as! String)
            print(" N I C K N A M E")
            print(member.valueForKey("Nickname")!)
            
            //        cell.detailTextLabel?.text = (member.valueForKey("Nickname") as! String)
            
        } else {
            cell.cellImageView?.image = UIImage(imageLiteral: "defaultProfile")
            cell.cellGreenLightImage.image = UIImage(imageLiteral: "salmonLight")
            cell.cellTitleLabel.text = "Kanye West"
            cell.detailTextLabel?.text = "@kanye"
            cell.cellGreenLightImage.hidden = false
            
            if profilePicture != nil {
                cell.cellImageView.image = profilePicture
            }
        }
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Fetching CKData
    
    func getBusiness() {
        let predicate = NSPredicate(format: " == %@", businessID!)
        let query = CKQuery(recordType: "Businesses", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil) { (organizations, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("performing query, Businesses: \(organizations![0]["name"])")
                self.currentBusiness = organizations![0] as CKRecord
                //                self.getTasks()
            }
        }
    }
    func fetchUsers() {
        if Business.sharedInstance.objectForKey("UIDEmployees") != nil {
            let references = Business.sharedInstance.objectForKey("UIDEmployees") as! [CKReference]
            
            let singleRef = references[0]
            
            self.getOneRecordOfType("Employees", reference: singleRef)
            
            let possiblyTaintedArray = [self.begottenRecord]
            var cleanArray: [CKRecord] = []
            var straightUpDisgustingArray: [CKRecord] = []
            if possiblyTaintedArray.count > 0 {
                for possibleTaint in possiblyTaintedArray {
                    if possibleTaint != nil {
                        if possibleTaint!.valueForKey("Name") != nil {
                            cleanArray.append(possibleTaint!)
                        } else {
                            straightUpDisgustingArray.append(possibleTaint!)
                        }
                    }
                    else {
                        
                        print("W U T I S G O I N G O N")
                    }
                }
                memberArray = cleanArray
                print("BINGO \(straightUpDisgustingArray.description)")
            }
        }
    }
    
    @IBAction func onRefreshTapped(sender: UIBarButtonItem) {
        self.fetchUsers()
        self.updateUsersOnlineLabel()
        self.tableView.reloadData()
    }
    func getTasks() {
        let taskReferenceArray = currentBusiness!.mutableArrayValueForKey("tasks")
        for taskRef in taskReferenceArray {
            publicDatabase.fetchRecordWithID(taskRef.recordID, completionHandler: { (task, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    if task != nil {
//                        self.memberArray.append(task!)
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
