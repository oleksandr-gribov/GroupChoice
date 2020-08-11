//
//  SimplifiedChatView.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/27/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import Foundation

struct SimplifiedChatView {
    var chatID: String
    var chatTitle: String?
    var lastMessage: String
    var otherUser: User
    
    init(chatID: String, chatTitle: String?, lastMessage: String, otherUser: User) {
        self.chatID = chatID
        self.chatTitle = chatTitle
        if chatTitle == nil {
            self.chatTitle = otherUser.username!
        }
        self.lastMessage = lastMessage
        self.otherUser = otherUser
    }
}



extension SimplifiedChatView: Equatable {
static func == (lhs: SimplifiedChatView, rhs: SimplifiedChatView) -> Bool {
    if lhs.chatID == rhs.chatID {
        return true
    }
    return false
    }
}
