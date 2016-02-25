//
//  EditCompnayViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class EditCompnayViewController: SuperViewController {

    @IBOutlet weak var companyNameTextField: UITextField!

    @IBOutlet weak var companyLocationTextField: UITextField!

    @IBOutlet weak var companyEmailTextField: UITextField!

    @IBOutlet weak var companyImageView: UIImageView!



    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func companyEditImageButtonTapped(sender: AnyObject) {
    }

    @IBAction func companySaveButtonTapped(sender: AnyObject) {
    }

    @IBAction func companyNameEdit(sender: AnyObject) {
        resignFirstResponder()
    }

    @IBAction func companyLocationEdit(sender: AnyObject) {
        resignFirstResponder()
    }

    @IBAction func companyEmailEdit(sender: AnyObject) {
        resignFirstResponder()
    }






}
