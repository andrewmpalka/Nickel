//
//  NewBusinessViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import CloudKit

class NewBusinessViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var businessNameTextField: UITextField!
    
    @IBOutlet weak var businessEmailTextField: UITextField!
    
    let placePlacerholder = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.businessEmailTextField.delegate = self
        self.businessNameTextField.delegate = self
    }
    
    func textFieldChecker(textField: UITextField) -> Bool {
        
        if(textField.text?.isEmpty == false) {
            if(validateFieldInput(textField.text!) == true) {
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
        if textFieldChecker(self.businessNameTextField) && textFieldChecker(self.businessEmailTextField) {
          self.businessHelper(self.businessNameTextField, email: self.businessEmailTextField, location: placePlacerholder)
        }
        return resignFirstResponder()
    }
}



