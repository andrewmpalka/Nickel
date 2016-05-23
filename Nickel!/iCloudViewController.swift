//
//  iCloudViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit
import DigitsKit
import Firebase
import GeoFire
import OAuthSwift


class iCloudViewController: SuperViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var cloudHelper: CKHelper?
    var user: User?
    var window: UIWindow?
    
    
    var bizRecord: CKRecord?
    var newEmployee: CKRecord?
    var employeeRef: CKReference?
    var bizRef: CKReference?
    var employeeArray = [] as NSMutableArray
    var seguedFromMemberSelect: Bool?
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var iCloudLogin: UIButton!
    @IBOutlet weak var workspaceLabel: UILabel!
    
    
    
    let locationManager = CLLocationManager()
    var placePlacerholder = CLLocation()
    
    
    @IBOutlet weak var uidTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        
        self.title = "Nickel28"
        
        
        
        cloudHelper = CKHelper()
        
        //        self.iCloudLoginAction()
        
        Digits.sharedInstance().logOut()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        
        bizRecord = Business.sharedInstance
        
        
        let clearTap = UITapGestureRecognizer(target: self, action: #selector(iCloudViewController.deselectBusiness))
        
        clearTap.numberOfTapsRequired = 1
            
        self.workspaceLabel.userInteractionEnabled = true
        
        
        self.workspaceLabel.addGestureRecognizer(clearTap)
        
        

        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        var int = 1
        repeat {
            print("APPEARED"); int += 1 }
        while int < 10;
        
        if BusinessObj.sharedInstance.name == "NULL" || BusinessObj.sharedInstance.name == nil {
        self.btnLogin.hidden = true
        self.iCloudLogin.hidden = true
            
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        } else {
            self.workspaceLabel.text = BusinessObj.sharedInstance.name
            self.btnLogin.hidden = false
            self.iCloudLogin.hidden = false
        }
        
    }
    
    func deselectBusiness() {
        self.workspaceLabel.text = ""
        BusinessObj.sharedInstance.name = nil
        BusinessObj.sharedInstance.location = nil
        BusinessObj.sharedInstance.city = nil
        BusinessObj.sharedInstance.profilePic = nil
        
        self.locationManager.startUpdatingLocation()

    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.btnLogin.hidden = true
        self.iCloudLogin.hidden = true
        
        spinner.hidesWhenStopped = true
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        self.spinner.startAnimating()
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) -> Void in
            
            if error != nil {
                print("Error: " +  error!.localizedDescription)
                return
            }
            
            //Checks for actual placemarks returned
            self.placePlacerholder = manager.location!
            if placemarks?.count > 0 {
                let pm = placemarks![0] as! CLPlacemark
                self.displayLocationInfo(pm) //custom function to be later defined below
            }
        }
    }
    
    //Jon Code
    func displayLocationInfo(placemark: CLPlacemark) {
        
        self.locationManager.stopUpdatingLocation()
        //        print(placemark.locality!)
        //        print(placemark.postalCode!)
        //        print(placemark.administrativeArea!)
        //        print(placemark.country!)
        //        print("THIS IS JUST FROM DISPLAY")
        ///
        let center = placemark.location
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        
        let circleQuery = DataServices.geoFire.queryAtLocation(center, withRadius: 0.1)
        
        var keyList = [String]()
        
        let queryHandle = circleQuery.observeEventType(.KeyEntered, withBlock: { key,location in
            //            print("Key '\(key)' entered the search area and is at location '\(location)'")
            if (keyList.count < 1 || (keyList.contains(key) == false)) {
                keyList.append(key)
            } else {
                print("NOPE")
                print(key)
            }
            
        })
        
        var businessList = [BusinessObj]()
        
        dispatch_sync(dispatch_get_global_queue(
            Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) {
    
                
            circleQuery.observeReadyWithBlock {
                //            print("Everything is all good")
                print(keyList.description)
                
                for aKey in keyList {
                    let ref = Firebase(url: DataServices.stdRef + "business/" + aKey + "/")
                    ref.queryLimitedToFirst(20).observeEventType(.Value, withBlock: { snapshot in
                        if let name = snapshot.value["name"] {
                            print(snapshot.value)
                            print(name!)
                            let bName = "\(name!)"
                            let business = BusinessObj(id: aKey, name: bName, profilePic: "NONE", location: placemark.location!)
                            businessList.append(business)
                            print("LIST LIST LIST LIST\(businessList)")
                        } else {
                            
                            print("no key")
                            //                        print(snapshot)
                            //                        print(aKey)
                        }
                    })
                  
                }
                }
        }
        let timer = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))
        )
        dispatch_after(timer, dispatch_get_main_queue()) {

                if businessList.count > 1 {
                    print("IMPLEMENT CHOICE \(businessList.count) \(businessList.description)")
                    
                    
                            let alert = UIAlertController(title: "Workspace Finder", message: "Are you trying to access any of these businesses?", preferredStyle: .ActionSheet)
                    
                    
                    for business in businessList {
                        if let title = business.name {
                        let action = UIAlertAction(title: title , style: .Default, handler: { alertAction in
                            
                            self.btnLogin.hidden = false
                            self.iCloudLogin.hidden = false
                            
                            
                            self.workspaceLabel.text = title
                            })
                            
                        alert.addAction(action)
                        }
                    }
                    
                            let retryActn = UIAlertAction(title: "Retry", style: .Destructive, handler: { alertAction in
                                
                                self.locationManager.startUpdatingLocation()
                                alert.dismissViewControllerAnimated(true, completion: {
                                    print("WORKING")
                                    self.locationManager.startUpdatingLocation()
                                })
                            })
                            let setupActn = UIAlertAction(title: "I don't have a workspace", style: .Destructive, handler: { alertAction in
                                self.performSegueWithIdentifier("noBusiness", sender: alertAction)
                            })
                            alert.addAction(retryActn)
                            alert.addAction(setupActn)
                            
                            self.presentViewController(alert, animated: true, completion: {
                                self.spinner.stopAnimating()

                            })
                            //        isYourLocation(self, location: placemark)
                    
                    
                    
                    
                    
                    
                } else if businessList.count == 0 {
                    print("UHHHH")
                    print("AFTER")
                    let alert = UIAlertController(title: "Workspace Finder", message: "No workspaces were found", preferredStyle: .ActionSheet)
                    let retryActn = UIAlertAction(title: "Retry", style: .Destructive, handler: { alertAction in
                        
                        print("W O R K I N G")
                        self.locationManager.startUpdatingLocation()
                        alert.dismissViewControllerAnimated(true, completion: {
                        })
                    })
                    let setupActn = UIAlertAction(title: "Create new workspace", style: .Destructive, handler: { alertAction in
                        self.performSegueWithIdentifier("noBusiness", sender: alertAction)
                    })
                    
                    alert.addAction(retryActn)
                    alert.addAction(setupActn)
                    
                    self.presentViewController(alert, animated: true, completion: {
                        self.spinner.stopAnimating()

                    })

                } else {
                    print("ADDING BUS")
                    if let nom = businessList[0].name {
                    BusinessObj.sharedInstance.name = businessList[0].name!
                    BusinessObj.sharedInstance.city = businessList[0].city
                    BusinessObj.sharedInstance.id = businessList[0].id
                    BusinessObj.sharedInstance.location = businessList[0].location
                    BusinessObj.sharedInstance.profilePic = businessList[0].profilePic
                    } else {
                        print("ERROR \(businessList.description)")
                        print("ERROR \(businessList[0])")
                        print("ERROR \(businessList[0].name)")
                        print("ERROR \(businessList[0].id)")
                        print("ERROR \(businessList[0].city)")
                    }
                    
                    if let msg = BusinessObj.sharedInstance.name {
                        if msg != "NULL" {
                            let alert = UIAlertController(title: "Workspace Finder", message: "Are you trying to access \(msg)?", preferredStyle: .ActionSheet)
                            
                            let yesActn = UIAlertAction(title: "Yes", style: .Destructive, handler: { alertAction in
                                
                                self.btnLogin.hidden = false
                                self.iCloudLogin.hidden = false

                                self.workspaceLabel.text = msg
                            })
                            let retryActn = UIAlertAction(title: "Retry", style: .Destructive, handler: { alertAction in
                                
                                self.locationManager.startUpdatingLocation()
                                alert.dismissViewControllerAnimated(true, completion: {
                                    print("WORKING")
                                    self.locationManager.startUpdatingLocation()
                                })
                            })
                            let setupActn = UIAlertAction(title: "I don't have a workspace", style: .Destructive, handler: { alertAction in
                                self.performSegueWithIdentifier("noBusiness", sender: alertAction)
                            })
                            alert.addAction(yesActn)
                            alert.addAction(retryActn)
                            alert.addAction(setupActn)
                            
                            self.presentViewController(alert, animated: true, completion: {
                                self.spinner.stopAnimating()

                            })
                            //        isYourLocation(self, location: placemark)
                        } else {
                            print("AFTER")
                            let alert = UIAlertController(title: "Workspace Finder", message: "No workspaces were found", preferredStyle: .ActionSheet)
                            let retryActn = UIAlertAction(title: "Retry", style: .Destructive, handler: { alertAction in
                                
                                print("W O R K I N G")
                                self.locationManager.startUpdatingLocation()
                                alert.dismissViewControllerAnimated(true, completion: {
                                })
                            })
                            let setupActn = UIAlertAction(title: "Create new workspace", style: .Destructive, handler: { alertAction in
                                self.performSegueWithIdentifier("noBusiness", sender: alertAction)
                            })
                            
                            alert.addAction(retryActn)
                            alert.addAction(setupActn)
                            
                            self.presentViewController(alert, animated: true, completion: {
                                
                                self.spinner.stopAnimating()
                                
                            })
                            
                        }
                    }
                }
    
        }
    }
    
    //Jon Code
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Error: " + error.localizedDescription)
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .NotDetermined, .Restricted, .Denied:
                print("No access")
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("Access")
            default:
                print("...")
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return resignFirstResponder()
    }
    //MARK iCloud Authentication
    // Action to be called when the user taps "login with iCloud"
    func iCloudLoginAction() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.iCloudLogin({ (success) -> () in
            if success {
                print("S U C C E S S")
                self.presentedViewController
                userDefaults.setObject(true, forKey: "Logged in")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewControllerWithIdentifier("revCon") as! SWRevealViewController
                self.localUser = self.user
                
                self.uniqueMemberNameCheck()
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                    self.presentViewController(viewController, animated: false, completion: nil)
                }
            } else {
                // TODO error handling
            }
        })
    }
    
    // Nested CloudKit requests for permission; for getting user record and user information.
    private func iCloudLogin(completionHandler: (success: Bool) -> ()) {
        self.cloudHelper!.requestPermission { (granted) -> () in
            if !granted {
                let iCloudAlert = UIAlertController(title: "iCloud Error", message: "There was an error connecting to iCloud. Check iCloud settings by going to Settings > iCloud.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                iCloudAlert.addAction(okAction)
                self.presentViewController(iCloudAlert, animated: true, completion: nil)
            } else {
                self.cloudHelper!.getUser({ (success, user) -> () in
                    if success {
                        self.user = user
                        self.cloudHelper!.getUserInfo(self.user!, completionHandler: { (success, user) -> () in
                            if success {
                                completionHandler(success: true)
                            }
                        })
                    } else {
                        // TODO error handling
                    }
                })
            }
        }
    }
    //MARK User Record Check
    func tiedToBusiness() -> Bool {
        publicDatabase.fetchRecordWithID((newEmployee?.recordID)!) { record, error in
        }
        if newEmployee?.recordID != nil {
            return true
        }
        return false
    }
    func uniqueMemberNameCheck() {
        if bizRecord?.mutableArrayValueForKey("UIDEmployees").count == 0 {
            createMember()
        } else {
            for employeeReference in (bizRecord?.mutableArrayValueForKey("UIDEmployees"))! {
                publicDatabase.fetchRecordWithID(employeeReference.recordID, completionHandler: { (resultRecord, error) -> Void in
                    
                    if error != nil {
                        print("Error Fetching Names for Uniequness Test: \(error?.description)")
                    } else {
                        
                        if resultRecord!["Name"] as? String == self.localUser?.name {
                            dispatch_async(dispatch_get_main_queue()) {
                                //                                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                //                                    self.errorAlert("Error", message: "\(self.bizRecord!["Name"]!) is already an employee here. Please logout of other device")
                                //                                })
                            }
                        } else {
                            self.createMember()
                        }
                    }
                })
            }
        }
        
    }
    //MARK: Attaching New Employee To Biz
    func joinBiz() {
        
        //        uidTextField.resignFirstResponder()
        
        let predicate = NSPredicate(format: "uid == %@", uidTextField.text!)
        let query = CKQuery(recordType: "Businesses", predicate: predicate)
        loadingAlert(self)
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print("error getting organization: \(error)")
            } else {
                if results != nil {
                    if (results!.count > 0) {
                        //                   self.orgRecordToJoin = results![0]
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            //                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            //                                self.performSegueWithIdentifier("", sender: self)
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            //                                self.errorAlert("Oops!", message: "That invite code doesn't exist. Please try again.")
                        })
                    }
                }
            }
        }
    }
    func createMember() {
        if newEmployee == nil {
            newEmployee = CKRecord(recordType: "Employees")
            newEmployee!.setValue(localUser?.name, forKey: "Name")
            
            bizRef = CKReference(recordID: bizRecord!.recordID, action: .None)
            newEmployee!.setValue(bizRef, forKey: "UIDBusiness")
            
            employeeRef = CKReference(recordID: newEmployee!.recordID, action: .None)
            
            setReferencesForBiz()
        }
    }
    
    func setReferencesForBiz() {
        if bizRecord!.mutableArrayValueForKey("UIDEmployees").count == 0 {
            employeeArray = [employeeRef!]
            bizRecord?.setObject(employeeArray, forKey: "UIDEmployees")
            modifyRecords([bizRecord!, newEmployee!])
        } else {
            employeeArray = bizRecord!.mutableArrayValueForKey("UIDEmployees")
            employeeArray.addObject(employeeRef!)
            //                            orgRecord?.setObject(memberArray, forKey: "members")
            modifyRecords([bizRecord!, newEmployee!])
        }
    }
    
    func modifyRecords (records: [CKRecord]) {
        print("Modify records function called")
        let saveRecordsOperation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        
        saveRecordsOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if error != nil {
                print("error saving member and organization: \(error!.description)"
                )
            }else {
                print("Successfully saved")
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.performSegueWithIdentifier("logInSegue", sender: self)
                })
            }
        }
        publicDatabase.addOperation(saveRecordsOperation)
    }
    
    func guestLogin() {
        print("GUEST REQUEST")
        let ref = Firebase(url: "https://nickelapp.firebaseio.com")
        ref.authAnonymouslyWithCompletionBlock { error, authData in
            if error != nil {
                // There was an error logging in anonymously
            } else {
                print("HIT")
                UserObj.sharedInstance.id = authData.uid
                UserObj.sharedInstance.device = authData.provider
                UserObj.sharedInstance.name = "Anonymous"
                // We are now logged in
                print("Guest Signed in")
                if DataServices.addGuest() {
                
                userDefaults.setObject(true, forKey: "Logged in")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewControllerWithIdentifier("revCon") as! SWRevealViewController
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    print("P R E S E N T I N G")
                    self.presentViewController(viewController, animated: false, completion: nil)
                }
                } else {
                    print("ERROR THROWING GUEST")
                }
                
            }
        }
        
    }
    
    
    @IBAction func didTapButton(sender: UIButton) {
        
        let oauthswift = OAuth2Swift(
            consumerKey:    GIT_CONSUMER_KEY,
            consumerSecret: GIT_SECRET_KEY,
            authorizeUrl:   "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType:   "token"
        )
        
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "nickel28://oauth-callback/github")!, scope: "user:email,user:follow", state: state, success: {
            credential, response, parameters in
            
            
            print("GOOD HERE")
            let ref = Firebase(url: "https://nickelapp.firebaseio.com/")
            print("CHECK")
            
            ref.authWithOAuthProvider("github", token:credential.oauth_token,
                withCompletionBlock: { error, authData in
                    if error != nil {
                        print("ERROR: \(error.description)")
                        // There was an error during log in
                    } else {
                        //                        print("Success!")
                        
                        //                        print(authData.auth)
                        
                        
                        typealias API_INFO = [String: AnyObject]
                        
                        let providerData = authData.providerData! as! Dictionary<String, AnyObject>
                        UserObj.sharedInstance.device = "github"
                        UserObj.sharedInstance.mapToSingletonFromDictionary(self.parseApiData(providerData))
                        print("Success!")
                        
                        if DataServices.addGuest() {
                            userDefaults.setObject("yes", forKey: "SignedIn")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewControllerWithIdentifier("revCon") as! SWRevealViewController
                            
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                print("P R E S E N T I N G")
                                self.presentViewController(viewController, animated: false, completion: nil)
                            }

                        } else {
                            print("ERROR ERROR ERROR")
                        }
                        // We have a logged in Github user
                    }
            })
            }, failure: { error in
                print(error.localizedDescription)
        })
        
    }
    
    /*
     let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
     configuration.appearance = DGTAppearance()
     
     configuration.appearance.logoImage = UIImage(named: "AppIcon")
     
     configuration.appearance.labelFont = UIFont(name: "HelveticaNeue-Bold", size: 16)
     configuration.appearance.bodyFont = UIFont(name: "HelveticaNeue-Italic", size: 16)
     
     configuration.appearance.accentColor = LIGHT_GRAY_COLOR
     configuration.appearance.backgroundColor = SALMON_COLOR
     Digits.sharedInstance().authenticateWithViewController(self, configuration: configuration) { (session, error) -> Void in
     if (session != nil) {
     //
     // TODO: associate the session userID with your user model
     self.btnLogin.setTitle("Your Digits User ID is " + session.userID, forState: UIControlState.Normal)
     
     //                let ref = Firebase(url: DataServices.nickelUser)
     let ref = Firebase(url: "https://nickelapp.firebaseio.com")
     
     
     let params = ["oauth_token" : session.authToken, "oauth_token_secret" : session.authTokenSecret, "user_id" : session.userID ] as [NSObject : AnyObject]!
     var int = 0
     ref.authWithCustomToken(params["oauth_token"] as! String, withCompletionBlock: { error, authData in
     repeat {
     print("Error \(error.description) or Auth \(authData) ")
     //                    })
     int += 1
     } while int < 10
     })
     
     /*
     ref.authWithOAuthProvider("twitter", parameters: params, withCompletionBlock: { error, authData in
     repeat {
     print("Error \(error.description) or Auth \(authData) ")
     //                    })
     int += 1
     } while int < 10
     })
     */
     let message = "Phone number: \(session!.phoneNumber)"
     let alertController = UIAlertController(title: "You are logged in!", message: message, preferredStyle: .Alert)
     
     alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: .None))
     
     
     self.presentViewController(alertController, animated: true, completion: .None)
     }
     else {
     print(error.localizedDescription)
     }
     
     }
     }
     */
    
    @IBAction func oniCloudTapped(sender: UIButton) {
        self.guestLogin()
    }
}

extension iCloudViewController {
    func parseApiData(providerData: [String: AnyObject]) -> [String: AnyObject] {
        
        var dictionary = [String: AnyObject]()
        
        for tuple in providerData {
            /*
             tuple.0
             -------
             0
             profileImageURL
             1
             accessToken
             2
             id
             3
             displayName
             4
             cachedUserProfile
             5
             username
             
             
             tuple.1
             -------
             0
             https://avatars.githubusercontent.com/u/16229834?v=3
             1
             cdf06a0931321a6b8c3e87e7e8bc4bdcb87d4120
             2
             16229834
             3
             Andy Palka
             4
             {
             "avatar_url" = "https://avatars.githubusercontent.com/u/16229834?v=3";
             bio = "<null>";
             blog = "<null>";
             company = "<null>";
             "created_at" = "2015-12-09T19:13:28Z";
             email = "<null>";
             "events_url" = "https://api.github.com/users/andrewmpalka/events{/privacy}";
             followers = 6;
             "followers_url" = "https://api.github.com/users/andrewmpalka/followers";
             following = 4;
             "following_url" = "https://api.github.com/users/andrewmpalka/following{/other_user}";
             "gists_url" = "https://api.github.com/users/andrewmpalka/gists{/gist_id}";
             "gravatar_id" = "";
             hireable = "<null>";
             "html_url" = "https://github.com/andrewmpalka";
             id = 16229834;
             location = "Chicago, IL";
             login = andrewmpalka;
             name = "Andy Palka";
             "organizations_url" = "https://api.github.com/users/andrewmpalka/orgs";
             "public_gists" = 0;
             "public_repos" = 22;
             "received_events_url" = "https://api.github.com/users/andrewmpalka/received_events";
             "repos_url" = "https://api.github.com/users/andrewmpalka/repos";
             "site_admin" = 0;
             "starred_url" = "https://api.github.com/users/andrewmpalka/starred{/owner}{/repo}";
             "subscriptions_url" = "https://api.github.com/users/andrewmpalka/subscriptions";
             type = User;
             "updated_at" = "2016-05-08T06:51:58Z";
             url = "https://api.github.com/users/andrewmpalka";
             }
             5
             andrewmpalka
             */
            dictionary.updateValue(tuple.1, forKey: tuple.0)
            print(dictionary)
        }
        return dictionary
    }
    
}
