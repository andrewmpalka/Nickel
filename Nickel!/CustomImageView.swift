//
//  CustomImageView.swift
//  Nickel28
//
//  Created by Andrew Palka on 5/18/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

@IBDesignable
class CustomImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            print("didSet CALLED")
            self.setupView()
        }
    }
    override func awakeFromNib() {
        
        self.layer.cornerRadius = self.frame.height/2
        self.setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        
        print("THIS IS GETTING SETUP")
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = DARK_GRAY_COLOR.CGColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        
        self.contentMode = UIViewContentMode.ScaleAspectFit
        self.image?.drawInRect(self.layer.frame)
        
    }
}

