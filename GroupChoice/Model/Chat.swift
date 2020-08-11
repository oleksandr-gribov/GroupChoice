//
//  Chat.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/14/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import Foundation
import Firebase

struct Chat {
    var chatID: String
    var groupChat: Bool
    var users: [User]
    var chatTitle: String?
    var lastMessage: Message?
    var dateLastActive: Date?
    
    init(chatID: String, users: [User], chatTitle: String?, lastMessage: Message?) {
        self.chatID = chatID
        self.users = users
        self.chatTitle = chatTitle
        self.lastMessage = lastMessage
        if users.count > 2 {
            self.groupChat = true
        } else {
            print(chatTitle)
            self.groupChat = false
            let currentUser = Auth.auth().currentUser
            for user in users {
                print(user)
                if user.uid != currentUser!.uid && chatTitle == nil {
                    print("found second user")
                    self.chatTitle = user.username
                }
            }
        }
    }
}




