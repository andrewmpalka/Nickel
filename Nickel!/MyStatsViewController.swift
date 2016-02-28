//
//  MyStatsViewController.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class MyStatsViewController: SuperViewController {

    @IBOutlet weak var myHoursThisWeekLabel: UILabel!
    @IBOutlet weak var avgHoursThisWeekLabel: UILabel!
    @IBOutlet weak var myHoursLastWeekLabel: UILabel!
    @IBOutlet weak var avgHoursLastWeekLabel: UILabel!
    @IBOutlet weak var myAvgHoursThisYearLabel: UILabel!
    @IBOutlet weak var avgHoursThisYearLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Stats"

    }
}
