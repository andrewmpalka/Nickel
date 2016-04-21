//
//  CustomTextField.swift
//  Push4Yeezy
//
//  Created by Andrew Palka on 3/31/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit


@IBDesignable
class CustomTextField: UITextField {
    @IBInspectable var inset: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet{
            self.setUpView()
        }
    }
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.textRectForBounds(bounds)
    }
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }
    func setUpView() {
        self.layer.cornerRadius = self.cornerRadius
    }
}

