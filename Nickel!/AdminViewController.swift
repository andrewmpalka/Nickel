//
//  AdminViewController.swift
//  
//
//  Created by Matt Deuschle on 3/1/16.
//
//

import UIKit

class AdminViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var UUIDTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Admin"

        UUIDTextField.delegate = self
        minorTextField.delegate = self
        majorTextField.delegate = self
        resignKeyboard()
        clearTextField()

        // set bar button item fonts
        if let font = UIFont(name: "Avenir", size: 15) {
            menuButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }

        if self.revealViewController() != nil {

            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }

    // resign keyboard if user touches anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resignKeyboard()
    }

    @IBAction func onChangeBusinessLocationTapped(sender: AnyObject) {

        resignKeyboard()
    }

    func resignKeyboard()
    {
        UUIDTextField.resignFirstResponder()
        minorTextField.resignFirstResponder()
        majorTextField.resignFirstResponder()
    }

    func clearTextField()
    {
        UUIDTextField.text = ""
        minorTextField.text = ""
        majorTextField.text = ""
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


}
