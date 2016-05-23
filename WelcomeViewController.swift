//
//  WelcomeViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit
import pop


class WelcomeViewController: SuperViewController {

    @IBOutlet weak var connectConstraint: NSLayoutConstraint!
    @IBOutlet weak var newBizConstraint: NSLayoutConstraint!
    @IBOutlet weak var demoConstraint: NSLayoutConstraint!

    var animationEngine: AnimationEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.reveal()
        
        self.animationEngine = AnimationEngine(constraints: [connectConstraint,
                                                             newBizConstraint,
                                                             demoConstraint], control: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
        
        BusinessObj.sharedInstance.name = nil
        BusinessObj.sharedInstance.city = nil
        BusinessObj.sharedInstance.id = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        
      self.animationEngine.animateOnScreen(nil, control: 1)
    }

    @IBAction func connectYourBusinessButtonTapped(sender: AnyObject) {
    }

    @IBAction func newBusinessButtonTapped(sender: AnyObject) {
    }

    @IBAction func demoButtonTapped(sender: AnyObject) {
    }
}
