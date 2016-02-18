//
//  GroupMessageTableViewCell.swift
//  Nickel!
//
//  Created by Matt Deuschle on 2/17/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import UIKit

class GroupMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageImageView: UIImageView!

    @IBOutlet weak var messageNameLabel: UILabel!

    @IBOutlet weak var messageTimeStamp: UILabel!

    @IBOutlet weak var groupMessageTextField: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
