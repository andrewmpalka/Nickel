//
//  PrivateMessageTableViewCell.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class PrivateMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var pmImageView: UIImageView!
    @IBOutlet weak var pmNameLabel: UILabel!
    @IBOutlet weak var pmTimeStamp: UILabel!
    @IBOutlet weak var pmTextField: UITextView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
