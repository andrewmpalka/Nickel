//
//  CompanyProfileViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class CompanyProfileViewController: SuperViewController {

    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyLocationLabel: UILabel!
    @IBOutlet weak var companyEmailLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profile"

        // set bar button item fonts
        if let font = UIFont(name: "Avenir", size: 15) {
            menuButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            editButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        


    }
    
    override func viewWillAppear(animated: Bool) {
        if userDefaults.valueForKey("companyPicture") != nil {
            self.companyProfilePicFromData(userDefaults.valueForKey("companyPicture") as! NSData)
            self.companyImageView.image = companyProfilePicture
        }
        
        //Once CloudKit saves EditProfile data, the labels should update
        if userDefaults.valueForKey("currentBusinessName") != nil {
            companyNameLabel.text = (userDefaults.valueForKey("currentBusinessName") as! String)
        }
        if userDefaults.valueForKey("currentBusinessLocation") != nil {
            companyLocationLabel.text = (userDefaults.valueForKey("currentBusinessLocation") as! String)
        }
        if userDefaults.valueForKey("currentBusinessEmail") != nil {
            companyEmailLabel.text = (userDefaults.valueForKey("currentBusinessEmail") as! String)
        }
        
    }


}
