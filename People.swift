//
//  People.swift
//  Nickel!
//
//  Created by Matt Deuschle on 3/3/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import Foundation

class People {

    var name : String
    var handle : String
    var email: String
    var profileImage: UIImage

    init()
    {
        name = ""
        handle = ""
        email = ""
        profileImage = UIImage()
    }

    init(name: String, handle: String, email: String, profileImage: UIImage)
    {
        self.name = name
        self.handle = handle
        self.email = email
        self.profileImage = profileImage
    }
}

