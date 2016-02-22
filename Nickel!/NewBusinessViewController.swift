//
//  NewBusinessViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

class NewBusinessViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var businessNameTextField: UITextField!
    
    @IBOutlet weak var businessEmailTextField: UITextField!
    
    let placePlacerholder = CLLocation()
    let coreLocationManager = CLLocationManager()
    let appDelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.businessEmailTextField.delegate = self
        self.businessNameTextField.delegate = self
        coreLocationManager.delegate = self
    }
    
    func textFieldChecker(textField: UITextField, indicator: Int) -> Bool {
        
        if(textField.text?.isEmpty == false) {
            if(validateFieldInput(textField.text!, identifier: indicator) == true) {
                return true
            }
            else {
                textField.textColor = .redColor()
                if textField == businessNameTextField {
                    businessEmailTextField.enabled = false
                    popAlertForNoText(self, textFieldNotDisplayingText: textField)
                } else {
                    popAlertForNoText(self, textFieldNotDisplayingText: textField)
                }
                popAlertForNoText(self, textFieldNotDisplayingText: textField)
                return false
            }
        }
        popAlertForNoText(self, textFieldNotDisplayingText: textField)
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textFieldChecker(self.businessNameTextField, indicator: 1) && textFieldChecker(self.businessEmailTextField, indicator: 2) {
        self.newBusinessHelper(self.businessNameTextField, email: self.businessEmailTextField, location: placePlacerholder)
            performSegueWithIdentifier("success", sender: self)
            self.appDelegate.reveal()

            return resignFirstResponder()
        }
        return resignFirstResponder()
    }
    

}



