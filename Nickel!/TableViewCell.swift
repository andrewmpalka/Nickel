//
//  TableViewCell.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/16/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellDetailLabel: UILabel!
    @IBOutlet weak var cellGreenLightImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
