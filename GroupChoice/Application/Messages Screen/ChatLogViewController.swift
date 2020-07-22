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
    var currentUser: Firebase.User = Auth.auth().currentUser!
    var ref: DatabaseReference!
    var messages: [Message] = []

    
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
            print("recepeint uid is \(recepeintUser.uid)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .red
        messageInputBar.sendButton.setTitleColor(.red, for: .normal)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    
        // need to set up view to have the input text field and the table view
      
    }

    func sendNewMessage(message: Message) {
        print("sent")
        self.ref.child("messages").child("testMessage").setValue(["message":"hello"])
        
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //When use press send button this method is called.
        
        let message = Message(id: UUID().uuidString, content: text, created: Date(), senderID: currentUser.uid, senderName: currentUser.email!)
        
        sendNewMessage(message: message)

        
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
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
    
