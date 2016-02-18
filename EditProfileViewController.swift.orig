//
//  EditProfileViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var handleLabel: UITextField!
    @IBOutlet weak var userRoleLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!

    
    // value to hold keyboard frmae size
    var keyboard = CGRect()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Profile"
        
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // tap to choose image
        let imgTap = UITapGestureRecognizer(target: self, action: "loadImg:")
        imgTap.numberOfTapsRequired = 1
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(imgTap)
        
        
        //rounds the image from a square to circle
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        // call alignment function
        alignment()
        
    }
    
    // Custom Function: to hide keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //Custom Function: Alignment
    
    func alignment() {
        
        //programatically assign page elements if necessary
        
    }
    
    // func to call UIImagePickerController
    func loadImg (recognizer : UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //Method to finalize actions with UIImagePickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profileImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // regex restrictions for email textfield
    func validateEmail (email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.rangeOfString(regex, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    // alert message function
    func alert (error: String, message : String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: TextField Delegate Functions
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    @IBAction func editProfilePictureTapped(sender: AnyObject) {
        
        // send profile picture

        
    }
    
    
    //User pressed the save button to update the profile information
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        // if incorrect email according to regex
        if !validateEmail(emailLabel.text!) {
            alert("Incorrect email", message: "please provide correct email address")
            return
        }
        
        // save filled in information
        
        
        // send profile picture
        
        
        // send filled information to server



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
