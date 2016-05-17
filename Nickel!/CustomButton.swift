//
//  CustomButton.swift
//  Push4Yeezy
//
//  Created by Andrew Palka on 3/31/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import pop

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.setUpView(1)
        }
    }
    /*      COMMENT OUT FOR MULTICOLOR CONTROL
     @IBInspectable var fontColor: UIColor = UIColor.init(red: 138, green: 159, blue: 124, alpha: 1.0) {
     didSet {
     self.setUpView(2)
     }
     }
     */
    override func awakeFromNib() {
        self.setUpView(1)
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView(1)
    }
    func setUpView(int: Int) {
        switch int {
        case 1:
            self.layer.cornerRadius = self.cornerRadius
            
            /*
            self.layer.shadowOpacity = 0.8
            self.layer.shadowRadius = 3.0
            self.layer.shadowOffset = CGSizeMake(0.0, 0.2)
            //        self.layer.shadowColor = OLIVE_GREEN.CGColor
            self.layer.shadowColor = UIColor(red: 157.00/255.00, green: 157.00/255.00, blue: 157.00/255.00, alpha: 0.5).CGColor
            self.layer.setNeedsLayout()
            */
            self.addTarget(self, action: #selector(CustomButton.scaleToSmall), forControlEvents: .TouchDown)
            self.addTarget(self, action: #selector(CustomButton.scaleToSmall), forControlEvents: .TouchDragEnter)
            self.addTarget(self, action: #selector(CustomButton.scaleAnimation), forControlEvents: .TouchUpInside)
            self.addTarget(self, action: #selector(CustomButton.scaleDefault), forControlEvents: .TouchDragExit)
            
        case 2:
            print("COMMENT THIS OUT FOR MULTICOLOR CONTROL")
        //            self.tintColor = self.fontColor
        default:
            print("Something went wrong")
        }
    }
    func scaleToSmall() {
        let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(0.95, 0.95))
        
        self.layer.pop_addAnimation(scaleAnim, forKey: "invertedPop")
    }
    func scaleAnimation() {
        let scaleAnim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(2.0, 2.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        scaleAnim.springBounciness = 9
        self.layer.pop_addAnimation(scaleAnim, forKey: "springPop")
    }
    func scaleDefault() {
        let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        self.layer.pop_addAnimation(scaleAnim, forKey: "defaultPop")
        
    }
}

