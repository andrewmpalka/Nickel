//
//  EditProfileViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var firstNameLabel: UITextField!

    @IBOutlet weak var lastNameLabel: UITextField!

    @IBOutlet weak var handleLabel: UITextField!

    @IBOutlet weak var userRoleLabel: UITextField!

    @IBOutlet weak var emailLabel: UITextField!




    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Profile"

    }

    @IBAction func editProfilePictureTapped(sender: AnyObject) {
    }

    @IBAction func saveButtonTapped(sender: AnyObject) {
    }

    @IBAction func firstNameEdit(sender: AnyObject) {
        resignFirstResponder()
    }
    @IBAction func lastNameEdit(sender: AnyObject) {
        resignFirstResponder()
    }
    @IBAction func handleEdit(sender: AnyObject) {
        resignFirstResponder()
    }
    @IBAction func roleEdit(sender: AnyObject) {
        resignFirstResponder()
    }
    @IBAction func emailEdit(sender: AnyObject) {
        resignFirstResponder()
    }




}
