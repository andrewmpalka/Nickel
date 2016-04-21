//
//  AnimationEngine.swift
//  Push4Yeezy
//
//  Created by Andrew Palka on 4/4/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
    
    //CLASS MAKES THIS STATIC
    class var offScreenRightPosition: CGPoint {
        return CGPointMake(UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds) - 50)
    }
    //Negative because you want this to go left
    class var offScreenLeftPosition: CGPoint {
        return CGPointMake(-(UIScreen.mainScreen().bounds.width), CGRectGetMidY(UIScreen.mainScreen().bounds) - 50)
    }
    class var ScreenCenterPosition: CGPoint {
        return CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds) - 50)
    }
    
    var OriginalConstants = [CGFloat]()
    var constraints: [NSLayoutConstraint]
    init(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            OriginalConstants.append(constraint.constant)
            constraint.constant = AnimationEngine.offScreenRightPosition.x
        }
        self.constraints = constraints
    }
    func animateOnScreen(delay: Int64?, control: Int) {
        
        var animDelay: Int64 = 0
        
        switch control {
        case 1:
            animDelay = ANIM_DELAY_TOP
        case 2:
            animDelay = ANIM_DELAY_MID
        case 3:
            animDelay = ANIM_DELAY_BOT
        default:
            animDelay = 0
        }
        
        
        /* TERNARY OPERATIONS: let variable =  THE VALUE OF  [ (boolean expression == true) ? (DO THIS) : (ELSE THIS)) ]
 */
        
        let d : Int64 = delay == nil ? Int64(Double(animDelay) * Double(NSEC_PER_SEC)) : delay!
        print("\(d)")
        let t = dispatch_time(DISPATCH_TIME_NOW, d)
        
        dispatch_after(t, dispatch_get_main_queue()) { 
            var index = 0
            repeat {
                let moveAnim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = self.OriginalConstants[index]
                moveAnim.springSpeed = 12
                moveAnim.springBounciness = 12
                
                if (index > 0) {
                    moveAnim.dynamicsFriction += 12 + CGFloat(index)

                }
                
                let constraint = self.constraints[index]
                constraint.pop_addAnimation(moveAnim, forKey: "moveOnScreen")
                
                index += 1
                
            } while index < self.constraints.count
        }
    }
    
    class func animateToPosition(view: UIView, position: CGPoint, completion: ((POPAnimation!, Bool) -> Void)) {
        let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        moveAnim.toValue = NSValue(CGPoint: position)
        moveAnim.springBounciness = 8
        moveAnim.springSpeed = 8
        moveAnim.completionBlock = completion
        view.pop_addAnimation(moveAnim, forKey: "moveToPosition")
        print("THIS HAS BEEN HIT")
        
    }
}