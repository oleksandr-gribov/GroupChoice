//
//  Chat.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/14/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import Foundation


struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {
            return nil
        }
        self.init(users: chatUsers)
    }
}

