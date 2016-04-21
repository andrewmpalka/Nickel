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

        let str4 = NSAttributedString(string: "Enter company name", attributes: [NSForegroundColorAttributeName:UIColor(red: 230, green: 230, blue: 230, alpha: 1.0)])
        companyNameTextField.attributedPlaceholder = str4

        let str5 = NSAttributedString(string: "Enter company location", attributes: [NSForegroundColorAttributeName:UIColor(red: 230, green: 230, blue: 230, alpha: 1.0)])
        companyLocationTextField.attributedPlaceholder = str5

        let str6 = NSAttributedString(string: "Enter company email", attributes: [NSForegroundColorAttributeName:UIColor(red: 230, green: 230, blue: 230, alpha: 1.0)])
        companyEmailTextField.attributedPlaceholder = str6
        
        
        if userDefaults.valueForKey("currentBusinessName") != nil {
            companyNameTextField.text = (userDefaults.valueForKey("currentBusinessName") as! String)
        }
        
        if userDefaults.valueForKey("currentBusinessLocation") != nil {
            companyLocationTextField.text = (userDefaults.valueForKey("currentBusinessLocation") as! String)
        }
        
        if userDefaults.valueForKey("currentBusinessEmail") != nil {
            companyEmailTextField.text = (userDefaults.valueForKey("currentBusinessEmail") as! String)
        }
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(EditCompnayViewController.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // tap to choose image
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(EditCompnayViewController.loadImg(_:)))
        imgTap.numberOfTapsRequired = 1
        companyImageView.userInteractionEnabled = true
        companyImageView.addGestureRecognizer(imgTap)
        
        //rounds the image from a square to circle
        companyImageView.layer.cornerRadius = companyImageView.frame.size.width / 2
        companyImageView.clipsToBounds = true

    }
    
    override func viewWillAppear(animated: Bool) {
        if userDefaults.valueForKey("companyPicture") != nil {
            self.companyProfilePicFromData(userDefaults.valueForKey("companyPicture") as! NSData)
            self.companyImageView.image = companyProfilePicture
        }
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
        
        let data = self.digitizePicture(companyImageView.image!)
        Business.sharedInstance.setValue(data, forKey: "CompanyProfilePicture")
        userDefaults.setValue(data, forKey: "companyPicture")
        
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
    

    @IBAction func companySaveButtonTapped(sender: AnyObject) {
        
        
        // save filled in information and send to CK
        let companyNameText = companyNameTextField.text
        userDefaults.setValue(companyNameText, forKey: "currentBusinessName")
        
        let companyLocationText = companyLocationTextField.text
        userDefaults.setValue(companyLocationText, forKey: "currentBusinessLocation")
        
        let companyEmailText = companyEmailTextField.text
        userDefaults.setValue(companyEmailText, forKey: "currentBusinessEmail")
        
        
    }


} //end of class
