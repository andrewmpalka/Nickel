//
//  ListViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation
import Firebase

class ListViewController: SuperViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfUsersOnlineButton: UIBarButtonItem!
    
    var memberArray = [CKRecord]?()
    var insideFieldMembers = [CKRecord]?()
    var currentBusiness: CKRecord?
    var checker = false
    
    let locationManager = CLLocationManager()
    var placePlaceholder = CLLocation()
    var aUser = User?()
    var employees = [EmployeeObj]()
    var guests = [GuestObj]()
    var occupants = [FireObj]()
    
    var employeeRoom: Int?
    var guestRoom: Int?
    
    override func viewDidLoad() {
        
        
        
        if let bizName = BusinessObj.sharedInstance.name {
                self.title = bizName
        } else {
            print("NO BUSINESS DETECTED")
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        let andy = People(name: "Andrew Palka", handle: "@palka", email: "andrew@email.com", profileImage: UIImage(imageLiteral: "andy"))
        let matt = People(name: "Matthew Deuschle", handle: "@palka", email: "andrew@email.com", profileImage: UIImage(imageLiteral: "matt"))
        let jon = People(name: "Jonathan Kilgore", handle: "@palka", email: "andrew@email.com", profileImage: UIImage(imageLiteral: "jon"))

        
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
        

        print("number of people \(self.employees.count) ")


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
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("APPEAR")
        if DETAIL_CLICKED != nil {
            if DETAIL_CLICKED == true {
                userDefaults.setValue(false, forKey: "DETAIL_CLICKED")
                userDefaults.synchronize()
                
                self.viewDidLoad()
            }
        }
        DataServices.roomSize = 0
        self.occupants = []

//        self.fetchUsers()
//        self.updateUsersOnlineLabel()
        
        if userDefaults.valueForKey("userPicture") != nil {
            self.profilePicFromData(userDefaults.valueForKey("userPicture") as! NSData)
        }

//        DataServices.updateFirebaseEmployee("offline", inRange: false)
        if ERROR_LOG == false {
    dispatch_async(dispatch_get_main_queue()) {
        
        var CATCH = FireObj(id: "CATCH", name: "CATCH", status: "CATCH", profilePic: "CATCH", inRange: false, alias: "CATCH")
        
        DataServices.listenForEmployeeUpdates { (employees) -> Void in
            self.employees = employees
            print(self.employees)
            print(self.employees.count)
            self.employeeRoom = self.employees.count
            print(self.employeeRoom)
            for obj in self.employees {
                
                print("ID \(obj.id)")
                
                if UserObj.sharedInstance.id != obj.id {
                self.occupants.insert(obj, atIndex: 0)
                } else {
                    CATCH = obj
                    print("Caught")
                }
            }; if UserObj.sharedInstance.id == CATCH.id {
                print("C A UG T")
                self.occupants.insert(CATCH, atIndex: 0)
            }
            
            if (self.guestRoom != nil && self.employeeRoom != nil) {
                DataServices.roomSize = self.guestRoom! + self.employeeRoom!
                print(DataServices.roomSize)
            } else if self.guestRoom != nil {
                DataServices.roomSize = self.guestRoom!
            } else if self.employeeRoom != nil {
                DataServices.roomSize = self.employeeRoom!
            } else {
                DataServices.roomSize = 0
            }
            
            self.tableView.reloadData()
            };   print("ROOM")
            print(self.employeeRoom)
        DataServices.listenForGuestUpdates { (guests) in
            self.guests = guests
            
            self.guestRoom = self.guests.count
            for obj in self.guests {
            
            print("ID \(obj.id)")
                
            if UserObj.sharedInstance.id != obj.id {
                if self.occupants.count == 0 {
                 self.occupants.insert(obj, atIndex: 0)
                } else {
                self.occupants.insert(obj, atIndex: (self.occupants.count - 1))
                }
            } else {
                CATCH = obj
                print("Caught")
                }
            }; if UserObj.sharedInstance.id == CATCH.id {
                print("C A UG T")
                self.occupants.insert(CATCH, atIndex: 0)
            }
            
            
            
            if (self.guestRoom != nil && self.employeeRoom != nil) {
                DataServices.roomSize = self.guestRoom! + self.employeeRoom!
                print(DataServices.roomSize)
            } else if self.guestRoom != nil {
                DataServices.roomSize = self.guestRoom!
            } else if self.employeeRoom != nil {
                DataServices.roomSize = self.employeeRoom!
            } else {
                DataServices.roomSize = 0
            }
            
            self.tableView.reloadData()
        }

        
        }
    }
}
//MARK: Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) -> Void in
            
            if error != nil {
                print("Error: " +  error!.localizedDescription)
                return
            }
            
            //Checks for actual placemarks returned
            self.placePlaceholder = manager.location!
            if placemarks?.count > 0 {
                let pm = placemarks![0]
                self.displayLocationInfo(pm) //custom function to be later defined below
            }
        }
    }
    
    //Jon Code
    func displayLocationInfo(placemark: CLPlacemark) {
        
        self.locationManager.stopUpdatingLocation()
        print(placemark.locality!)
        print(placemark.postalCode!)
        print(placemark.administrativeArea!)
        print(placemark.country!)
        isYourLocation(self, location: placemark)
    }
    
    //Jon Code
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Error: " + error.localizedDescription)
        
    }
    
    
    func updateUsersOnlineLabel() {
        self.numberOfUsersOnlineButton.title = String(stringInterpolationSegment: DataServices.roomSize)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        numberOfUsersOnlineButton.title = String(DataServices.roomSize)


        return DataServices.roomSize
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID") as! TableViewCell
        cell.selectionStyle = .None
        if self.occupants.count < DataServices.roomSize {
            self.tableView.reloadData()
        }
        let employee = self.occupants[indexPath.row]
        
        
        cell.cellTitleLabel.text = employee.name
        
//        cell.cellDetailLabel.text = employee.status

        let fullName = employee.name
        
        cell.cellDetailLabel.text = "@\(employee.alias!)"
        
//        if fullName == "Andrew Palka" || fullName == "Matt Deuschle" || fullName == "Jonathan Kilgore" {
//            let image = userProfilePicDict[fullName!]
        
//            let h = cell.imageView?.frame.size.height
//            let l = cell.imageView?.frame.size.width
            
            
            
//            cell.imageView?.image = image
//            cell.imageView?.sizeToFit()
//            cell.imageView?.clipsToBounds = true
        if employee.profilePic != "NULL" {
            print(cell.imageView?.frame)
            let url = NSURL(string: employee.profilePic!)
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)

            cell.cellImageView.image = image
//            cell.imageView?.image = image

//            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
//            cell.imageView?.clipsToBounds = true
            
            
            
            var bounds = cell.imageView?.frame
            bounds?.origin = CGPointZero
            print("\((image?.size))")

            
            
            
        } else {
            print("NOOOOPE")
            cell.cellImageView?.image = UIImage(imageLiteral: "defaultProfile")

        }
        
        
        // TRYING TO FIGURe Out BEACONS
        
        if employee.status == "in" {
            cell.cellGreenLightImage.hidden = false
        }
        else {
            cell.cellGreenLightImage.hidden = true
        }



//        // TRYING TO ADD PICS
//        if userDefaults.valueForKey("userPicture") != nil {
//            self.profilePicFromData(userDefaults.valueForKey("userPicture") as! NSData)
//            cell.imageView?.image = profilePicture
//        }


        return cell
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let dvc = segue.destinationViewController as! UserProfileViewController
        dvc.selectedEmployee = self.occupants[indexPath!.row] 
    }
    
}
