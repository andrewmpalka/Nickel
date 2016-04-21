//
//  DetailViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class DetailViewController: SuperViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // set bar button item fonts
        if let font = UIFont(name: "Avenir", size: 15) {
            menuButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            editButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }

        self.title = "Profile"

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        


        let fullName = User.sharedInstance.name
        let fullNameArr = fullName!.characters.split{$0 == " "}.map(String.init)
        let firstName = fullNameArr[0]
        userHandleLabel.text = "@\(firstName)"

//        if User.sharedInstance.nickname != nil {
//            userHandleLabel.text = User.sharedInstance.nickname
//        }



    }
    
    override func viewWillAppear(animated: Bool) {
        if userDefaults.valueForKey("userPicture") != nil {
            self.profilePicFromData(userDefaults.valueForKey("userPicture") as! NSData)
            self.imageView.image = profilePicture
        }
        
        if User.sharedInstance.name != nil {
            userNameLabel.text = User.sharedInstance.name
        }
        
        if User.sharedInstance.positionTitle != nil {
            userTitleLabel.text = User.sharedInstance.positionTitle
        }
        
        if User.sharedInstance.emailAddress != nil {
            userEmailLabel.text = User.sharedInstance.emailAddress
        }
    }



}
