//
//  ChatLogViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 9/27/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

class ChatLogViewController: MessagesViewController,InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    var currentUser: User!
    
    var secondUser: User!
    var ref: DatabaseReference!
    var messages: [Message] = []
    var isNewChat: Bool!
    var chatID: String!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.title = chatTitle
        if chatID != nil {
           fetchMessages(chatdID: self.chatID)
        }

    }
    public static let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
        formatter.timeStyle = .full
           formatter.locale = Locale(identifier: "en_US_POSIX")
           return formatter
       }()
    
    func currentSender() -> SenderType {
        return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
        }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
            //print("There are no messages")
            return 0
        } else {
            return messages.count
        }
    }
    
    
    var recepeintUser: User! {
        didSet {
            self.navigationItem.title = recepeintUser.username
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        currentUser = TabBarViewController.self.currentUser
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .red
        messageInputBar.sendButton.setTitleColor(.red, for: .normal)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    
      
    }
    
    // MARK: - Sending messages

    func sendNewMessage(message: Message) {
        
        if chatID == nil {
            chatID = UUID().uuidString
        }
        
        let currRef = self.ref.child("conversations/messages").child(self.chatID).childByAutoId()
        
        currRef.updateChildValues(message.dictionary)
    
        if self.isNewChat {
            createNewChat(chatKey: self.chatID, currentUser: currentUser, secondUser: secondUser, message: message)
        }
        
        print("sent")
        
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //When use press send button this method is called.
        
        let message = Message(id: UUID().uuidString, content: text, created: Date(), senderID: currentUser.uid!)
        
        sendNewMessage(message: message)

        
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        
    }
    
    // MARK: - Saving a new chat
    
    /// Gets triggered when a new message is sent in the chat so as to not save empty chats
    private func createNewChat(chatKey: String, currentUser: User, secondUser: User, message: Message) {
        let currRef = self.ref.child("conversations").child("chats").child(chatKey)
         let lastMessageString = message.sender.displayName + ": " + message.content
        let dict = ["title": nil,
                           "lastMessage": lastMessageString,
                           "timestamp":message.createdDateString] as [String : Any]

               currRef.updateChildValues(dict) { (Error, DatabaseReference) in

               }
               let membersRef = self.ref.child("conversations").child("members").child(chatKey).child("users")
               let values = [currentUser.uid : true,
                             secondUser.uid: true]

               membersRef.updateChildValues(values) { (err, db) in
               }
        self.assignChatToUser(chatID: chatKey, userID: currentUser.uid!)
        self.assignChatToUser(chatID: chatKey, userID: secondUser.uid!)
        self.isNewChat = false
    }
    
    private func assignChatToUser(chatID: String, userID: String) {
        let usersRef = self.ref.child("users").child(userID).child("chats")
        
        let dict = [chatID: true]
        usersRef.updateChildValues(dict) { (error, DatabaseReference) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchMessages(chatdID: String) {
        ref.child("conversations/messages").child(self.chatID).observe(.value) { (snapshot) in
            for child in snapshot.children {
                if let message = child as? DataSnapshot {
                    let content = message.childSnapshot(forPath: "content").value as! String
                    let created = message.childSnapshot(forPath: "created").value as! String
                    let senderID = message.childSnapshot(forPath: "senderID").value as! String
                    
                    print("Created from firebase is \(created)")
                    let date = ChatLogViewController.dateFormatter.date(from: created)
                    
                    print(date)
                    let newMessage = Message(id: message.key, content: content, created: date!, senderID: senderID)
                    
                    if !self.messages.contains(newMessage) {
                        self.messages.append(newMessage)
                    }
                    
                    
                }
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom(animated: true)
                }
            }
        }
        
        
        
    }
    
    //MARK: - Messages Display Delegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }
    //THis function shows the avatar
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //If it's current user show current user photo.
        if message.sender.senderId == currentUser.uid {
            // fetch current user image
        } else {
            // fetch receiver image
            }
        }
    }
    //Styling the bubble to have a tail
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
//        return .bubbleTail(corner, .curved)
//    }
    
