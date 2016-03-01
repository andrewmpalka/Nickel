//
//  UserProfileViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class UserProfileViewController: SuperViewController {

    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberNameHandel: UILabel!
    @IBOutlet weak var memberRoleLabel: UILabel!
    @IBOutlet weak var memberEmailLabel: UILabel!
    @IBOutlet weak var messageButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile"
        
        // set bar button item fonts
        if let font = UIFont(name: "Avenir", size: 15) {
            messageButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        //Once user data is stored in CK, this should override default data
        if User.sharedInstance.name != nil {
            memberNameLabel.text = User.sharedInstance.name
        }
        
        if User.sharedInstance.nickname != nil {
            memberNameHandel.text = User.sharedInstance.nickname
        }
        
        if User.sharedInstance.positionTitle != nil {
            memberRoleLabel.text = User.sharedInstance.positionTitle
        }
        
        if User.sharedInstance.emailAddress != nil {
            memberEmailLabel.text = User.sharedInstance.emailAddress
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if userDefaults.valueForKey("userPicture") != nil {
            self.profilePicFromData(userDefaults.valueForKey("userPicture") as! NSData)
            self.memberImageView.image = profilePicture
        }
    }

}
