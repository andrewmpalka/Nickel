//
//  EditCompnayViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class EditCompnayViewController: SuperViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyLocationTextField: UITextField!
    @IBOutlet weak var companyEmailTextField: UITextField!
    @IBOutlet weak var companyImageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Company"
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // tap to choose image
        let imgTap = UITapGestureRecognizer(target: self, action: "loadImg:")
        imgTap.numberOfTapsRequired = 1
        companyImageView.userInteractionEnabled = true
        companyImageView.addGestureRecognizer(imgTap)
        
        //rounds the image from a square to circle
        companyImageView.layer.cornerRadius = companyImageView.frame.size.width / 2
        companyImageView.clipsToBounds = true

    }
    
    // Custom Function: to hide keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
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
        companyImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    // regex restrictions for email textfield
    func validateEmail (email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.rangeOfString(regex, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }


    @IBAction func companySaveButtonTapped(sender: AnyObject) {
        
        // if incorrect email according to regex
        if !validateEmail(companyEmailTextField.text!) {
            alert("Incorrect email", message: "please provide correct email address")
            return
        }
        
        //User.sharedInstance.userRecordID = recID
        
        // save filled in information and send to CK

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
