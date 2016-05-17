//
//  Keys.swift
//  Nickel28
//
//  Created by Andrew Palka on 5/9/16.
//  Copyright © 2016 Andrew Palka. All rights reserved.
//

import OAuthSwift


let GIT_CONSUMER_KEY = "ad9074195f0d888496dd"
let GIT_SECRET_KEY = "ed64f87cc6c2a891a3a2a4d2646ac16f50b3b1bb"
let GIT_OAUTH_URL = "https://api.github.com/applications/grants/1"

let gitOAUTH = OAuth2Swift(consumerKey: GIT_CONSUMER_KEY, consumerSecret: GIT_SECRET_KEY, authorizeUrl: GIT_OAUTH_URL, responseType: "token")


