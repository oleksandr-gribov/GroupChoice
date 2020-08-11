//
//  User.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 9/25/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit

class User: NSObject {
    var uid: String?
    var username: String?
    var email: String?
    
    init(uid: String, username: String, email: String) {
        self.uid = uid
        self.username = username
        self.email = email
    }
}
