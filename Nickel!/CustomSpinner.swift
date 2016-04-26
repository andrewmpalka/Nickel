//
//  CustomSpinner.swift
//  Push4Yeezy
//
//  Created by Andrew Palka on 4/6/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class CustomSpinner: UIActivityIndicatorView {
    
    @IBInspectable var spColor: UIColor? = SALMON_COLOR {
        didSet{
            self.setUpView()
        }
    }
    override func awakeFromNib() {
        self.color = self.spColor
        self.tintColor = self.spColor
    }
    func setUpView(){
        self.activityIndicatorViewStyle = .WhiteLarge
        self.color = self.spColor
        self.tintColor = self.spColor

    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
