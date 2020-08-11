//
//  FavortitesViewController.swift
//  GroupChoice
//
//  Created by Oleksandr Gribov on 7/31/19.
//  Copyright © 2019 Oleksandr Gribov. All rights reserved.
//

import UIKit
import Firebase

class AllMessagesViewController: UITableViewController {
    var users = [User]()
    let cellID = "cellID"
    var chats = [SimplifiedChatView]()
    var ref : DatabaseReference!
    var currentUser: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
               
        self.ref = Firebase.Database.database().reference()
        
        currentUser = TabBarViewController.self.currentUser
       
        
        fetchChatIDsForUser()
        
        print(chats)
        self.navigationItem.title = "Chats"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMessage))
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func newMessage() {
        let newMessageVC = NewMessageViewController()
        newMessageVC.messageVC = self
        newMessageVC.currentUser = currentUser
        
        present(UINavigationController(rootViewController: newMessageVC), animated: true, completion: nil)
    }
    
    /// Fetches all the chats current user is a member of
    func fetchChatIDsForUser() {
        ref.child("users").child(currentUser.uid!).child("chats").observe(.value) { (snapshot) in
            for child in snapshot.children  {
                if let chat = child as? DataSnapshot {
                    print(chat.key)
                    
                    self.fetchChat(chatID: chat.key)
                }
            }
        }
    }
    
    /// Fetches chat by chatID
    func fetchChat(chatID: String) {
        ref.child("conversations/chats").child(chatID).observe(.value) { (snapshot) in
            let title = snapshot.childSnapshot(forPath: "title").value as? String
            let lastMessage = snapshot.childSnapshot(forPath: "lastMessage").value as! String
            
            self.fetchMembersForChat(chatID: chatID) { (otherUserID) in
                if otherUserID != nil {
                    self.fetchUserData(userID: otherUserID) { (User) in
                        if let user = User {
                            let newChat = SimplifiedChatView(chatID: chatID, chatTitle: title, lastMessage: lastMessage, otherUser: user)
                            print(newChat)
                            if !self.chats.contains(newChat) {
                                self.chats.append(newChat)
                                
                                DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
            
            }
        }
    }
    
    func fetchMembersForChat(chatID: String, completion: @escaping (String) -> ()) {
        
        ref.child("conversations/members").child(chatID).observe(.value) { (snapshot) in
            let users = snapshot.childSnapshot(forPath: "users").value as! NSDictionary
            for key in users.allKeys {
                if key as! String != self.currentUser.uid! {
                    completion("\(key)")
                }
            }
        }
        
    }
    
    func fetchUserData(userID: String, completion: @escaping (User?) -> ()) {
        ref.child("users").observe(.value){ (snapshot, err) in
            if let err = err {
                print(err)
                completion(nil)
            }
            for child in snapshot.children {
                if let firebaseUser = child as? DataSnapshot {
                    if firebaseUser.key == userID {
                        let email = firebaseUser.childSnapshot(forPath: "email").value as! String
                        let username = firebaseUser.childSnapshot(forPath: "username").value as! String
                        completion(User(uid: firebaseUser.key, username: username, email: email))
                    }
                }
            }
        }
    }
    
    // MARK: - TableView methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let chat = chats[indexPath.row]
        
        cell.textLabel?.text = chat.chatTitle
        cell.detailTextLabel?.text = chat.chatID
        
        
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        let chatlogVC = ChatLogViewController()
        chatlogVC.chatID = chat.chatID
        chatlogVC.currentUser = currentUser!
        chatlogVC.isNewChat = false 
        navigationController?.pushViewController(chatlogVC, animated: true)
    }
    func showViewController (user: User) {
        let chatlogVC = ChatLogViewController()
        chatlogVC.recepeintUser = user
        chatlogVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatlogVC, animated: true)
        
    }
}

class NewMessageCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
