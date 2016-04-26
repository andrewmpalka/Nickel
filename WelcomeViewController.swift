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
        
        self.animationEngine = AnimationEngine(constraints: [connectConstraint,
                                                             newBizConstraint,
                                                             demoConstraint])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
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
