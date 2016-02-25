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


    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }


}
