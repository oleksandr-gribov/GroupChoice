//
//  Message.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/14/20.
//  Copyright © 2020 Oleksandr Gribov. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MessageKit

struct Message {
    var id: String
    var content: String
    var created: Date
    var senderID: String
    var createdDateString: String
    var dictionary: [String: Any] {
        return [
            "content": content,
            "created": createdDateString,
            "senderID": senderID]
    }
    
    init(id: String, content: String, created: Date, senderID: String) {
        self.id = id
        self.content = content
        self.created = created
        self.createdDateString = ChatLogViewController.dateFormatter.string(from: created)
        self.senderID = senderID
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? Date,
            let senderID = dictionary["senderID"] as? String,
            let senderName = dictionary["senderName"] as? String
            else {return nil}
        self.init(id: id, content: content, created: created, senderID: senderID)
    }
}

extension Message: MessageType {
    var sentDate: Date {
        return created
    }
    var sender: SenderType {
        return Sender(id: senderID, displayName: senderID)
    }
    var messageId: String {
        return id
    }
    
    var kind: MessageKind {
        return .text(content)
    }
}

extension Message: Equatable {
static func == (lhs: Message, rhs: Message) -> Bool {
    if lhs.messageId == rhs.messageId {
        return true
    }
    return false
    }
}

